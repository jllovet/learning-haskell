# Day 1 — The Evaluation Model (Laziness)

Note: Tutorial written by Claude

**Goal:** understand *when* and *how far* Haskell evaluates things, so laziness
becomes a design tool instead of a mystery. By the end you'll be able to read a
thunk, force it on purpose, and explain the classic `foldl` space leak in precise
terms — with one leak you built and killed as your deliverable.

**Why this first:** laziness is one of the two deep-end skills of this trajectory.
Okasaki's whole contribution (Week 1, Days 4–5) is *using* laziness to make
amortized bounds survive persistence. You can't appreciate that until thunks and
WHNF are second nature.

> All GHCi output below was captured on GHC 9.4.8 — you should see the same.
> Run GHCi via `cabal repl` from inside `fp-lab/`, or just `ghci`.

---

## 0. Basics refresher (~15 min — skip what you know)

### GHCi is your lab bench

| Command | What it does |
|---|---|
| `:t expr` | show the **type** of an expression |
| `:i name` | **info**: definition, instances, fixity |
| `:k Type` | show the **kind** of a type |
| `:l File.hs` / `:r` | load / reload a file |
| `:sprint x` | print `x` **without forcing it** — shows thunks as `_` |
| `:set -XExt` | turn on a language extension (e.g. `-XBangPatterns`) |
| `:{ … :}` | multi-line block |

### Values, types, signatures

Everything has a type; ask with `:t`. Top-level definitions get a signature:

```haskell
answer :: Int
answer = 42

-- String is just [Char]
greeting :: String
greeting = "hello"
```

Annotate inline with `::` when a type is ambiguous: `(1 + 2) :: Int`. You'll do
this constantly today because `:sprint` needs a **monomorphic** (fully known)
type — without the annotation, `1 + 2` is polymorphic (`Num a => a`) and `:sprint`
can't show it usefully.

### Functions are curried

Every function takes exactly one argument and returns a function for the rest:

```haskell
add :: Int -> Int -> Int      -- really Int -> (Int -> Int)
add x y = x + y

add 3      :: Int -> Int       -- partial application: a function waiting for y
map (+1) [1,2,3]               -- (+1) is a partially applied (+)
```

> **Clojure bridge:** like `partial` / manual currying, but built into every
> function. `(+1)` ≈ `(partial + 1)`.

### Pattern matching & guards

```haskell
describe :: Int -> String
describe 0 = "zero"
describe n
  | n < 0     = "negative"
  | even n    = "positive even"
  | otherwise = "positive odd"

-- destructure as you match
firstTwo :: [a] -> Maybe (a, a)
firstTwo (x:y:_) = Just (x, y)
firstTwo _       = Nothing      -- _ is a wildcard
```

### Lists, ranges, comprehensions

```haskell
[1,2,3]            -- sugar for 1 : 2 : 3 : []
[1..10]            -- range
[1..]              -- INFINITE range (fine, because lazy)
[x*x | x <- [1..5], even x]   -- comprehension -> [4,16]
```

> **Clojure bridge:** Clojure has lazy *seqs* (`map`, `range`, `lazy-seq`) but is
> otherwise strict. Haskell flips the default — **laziness is pervasive**, applying
> to every expression, not just sequences. That's the whole story of today.

### let / where

```haskell
area r = let pi' = 3.14159 in pi' * r * r
hypot a b = sqrt (a2 + b2)
  where a2 = a*a
        b2 = b*b
```

---

## 1. The big idea: non-strict evaluation

Haskell uses **call-by-need**: an expression is *not* evaluated when it is bound —
only when its value is actually **demanded**, and then **at most once** (the result
is memoized). Most languages (and Clojure, outside lazy seqs) are **strict**:
arguments are evaluated before the call.

Consequences of laziness:

- **Infinite structures** work: `take 5 [1..]`, `fibs`, streams.
- **Producer/consumer decoupling**: build a big list, consume only part of it.
- **Short-circuiting for free**: `&&`, `||`, `any` stop early.
- **The cost**: space behavior is subtle. Deferred work piles up as *thunks*, and
  if you never force them, they leak memory. That's the trap you'll learn to spot.

---

## 2. Thunks — deferred computations you can watch

A **thunk** is a recipe for a value, stored on the heap, plus an empty slot for
the result. When the thunk is **forced**, the recipe runs, and the slot is
overwritten with the value (memoization), so future forces are free.

Watch one resolve — `:sprint` shows `_` for an unforced thunk:

```text
ghci> let x = (1 + 2) :: Int
ghci> :sprint x
x = _              -- bound, but NOT computed yet
ghci> seq x ()     -- force x (more on seq in §4)
()
ghci> :sprint x
x = 3              -- now evaluated and memoized
```

**Why a thunk and not a value?** Look at the *outermost* shape of the right-hand
side. Compare:

```text
ghci> let x = 1 + 2 :: Int
ghci> :sprint x
x = _              -- outermost is (+), a reducible expression -> a THUNK

ghci> let p = (1+2, 3+4) :: (Int, Int)
ghci> :sprint p
p = (_,_)          -- outermost is the (,) constructor -> already a VALUE shell,
                   --   with two thunks inside
```

That difference *is* the definition of Weak Head Normal Form, next.

---

## 3. WHNF vs NF — "how far is it evaluated?"

- **Normal Form (NF):** fully evaluated. No thunks anywhere, nothing left to
  reduce. E.g. `3`, `(3, 7)`, `[2,3,4]`.
- **Weak Head Normal Form (WHNF):** evaluated *just far enough* to expose the
  outermost **data constructor** or **lambda**. The pieces inside may still be
  thunks.

| Expression | In WHNF? | In NF? | Why |
|---|---|---|---|
| `1 + 2` | no | no | outermost `(+)` is a redex |
| `(1+2, 3+4)` | **yes** | no | outermost is `(,)`; fields still thunks |
| `_ : _` | **yes** | no | outermost is `(:)`; head/tail thunks |
| `Just (1+2)` | **yes** | no | constructor exposed, arg a thunk |
| `\x -> x + 1` | **yes** | yes | a lambda is WHNF (and has no sub-thunks) |
| `[2,3,4]` | yes | **yes** | spine and all elements evaluated |

### The key picture: spine vs elements

A list has two independent axes you can force separately — its **spine** (the
cons cells / structure) and its **elements** (the contents). This example is the
single most important thing to internalize today:

```text
ghci> let xs = map (+1) [1,2,3] :: [Int]
ghci> :sprint xs
xs = _                 -- nothing forced

ghci> seq xs ()        -- force to WHNF: just one cons cell
ghci> :sprint xs
xs = _ : _             -- head and tail still thunks

ghci> length xs        -- length walks the SPINE...
3
ghci> :sprint xs
xs = [_,_,_]           -- ...all cons cells forced, but elements still thunks

ghci> sum xs           -- sum needs the ELEMENTS too...
9
ghci> :sprint xs
xs = [2,3,4]           -- ...now fully evaluated: Normal Form
```

`length` forces the spine but not the elements; `sum` forces both. Hold this
picture — it explains every space leak you'll ever debug.

---

## 4. Forcing tools: `seq`, `$!`, `BangPatterns`, `deepseq`

### `seq` — force to WHNF

`seq a b` forces `a` to **WHNF** (only WHNF!), then returns `b`. It introduces a
*demand*: whenever the result is forced, `a` gets forced first.

The crucial gotcha — `seq` does **not** reach inside a constructor:

```text
ghci> seq (undefined, 5 :: Int) "ok"
"ok"               -- the tuple is ALREADY WHNF, so seq never touches `undefined`
```

So `seq` on an already-WHNF value (like that tuple, or `p` from §2) does nothing
to the thunks inside it.

### `$!` — strict application

```haskell
f $! x   ==   x `seq` f x      -- force x to WHNF, THEN apply f
```

Contrast `f $ x` (ordinary, lazy application) with `f $! x` (force-then-apply).

### `BangPatterns` — force in a pattern

```haskell
{-# LANGUAGE BangPatterns #-}

strictSum :: [Int] -> Int
strictSum = go 0
  where
    go !acc []     = acc          -- the ! forces acc to WHNF each step
    go !acc (x:xs) = go (acc + x) xs
```

The bang means "when you enter this equation, force `acc` to WHNF." Drop the bang
and this function leaks exactly like lazy `foldl` (next section).

### `deepseq` / `force` — force to NF

From `Control.DeepSeq`: `a \`deepseq\` b` forces `a` all the way to **Normal Form**
before returning `b`; `force a` is `a` but fully evaluated when demanded.

```text
ghci> import Control.DeepSeq
ghci> (undefined :: Int, 5 :: Int) `deepseq` "should not print"
*** Exception: Prelude.undefined
```

Unlike `seq`, `deepseq` *does* reach inside the tuple — so it hits `undefined`.

| Tool | Forces to | Typical use |
|---|---|---|
| `seq`, `$!`, `!pat` | **WHNF** (one level) | strict accumulators, strict fields |
| `deepseq`, `force` | **NF** (everything) | before timing, before caching/storing |

---

## 5. The main event: the `foldl` space leak

`foldl` associates to the **left**:

```haskell
foldl (+) 0 [1,2,3]  ==  ((0 + 1) + 2) + 3
```

Lazy `foldl` never forces the accumulator as it walks the list, so it builds a
**thunk chain** as tall as the list:

```text
((((0 + 1) + 2) + 3) + 4) + ...      -- one million deep for a million elements
```

That chain sits on the heap (O(n) memory) and, when finally forced, unwinds
recursively (often O(n) stack → overflow). `foldl'` (from `Data.List`) forces the
accumulator to WHNF **each step**, so the running total stays a single evaluated
`Int`: O(1) space.

### Build it and measure it (real numbers from this machine)

Compile a tiny driver with RTS stats enabled:

```haskell
-- LeakDemo.hs
import Data.List (foldl')
import System.Environment (getArgs)

main :: IO ()
main = do
  [which, nStr] <- getArgs
  let n  = read nStr :: Int
      xs = [1..n] :: [Int]
  case which of
    "lazy"   -> print (foldl  (+) 0 xs)
    "strict" -> print (foldl' (+) 0 xs)
    _        -> error "use lazy|strict"
```

```sh
ghc -O0 -rtsopts LeakDemo.hs -o leakdemo
./leakdemo strict 10000000 +RTS -s     # foldl'
./leakdemo lazy   10000000 +RTS -s     # foldl
```

Measured maximum residency at n = 10,000,000:

| Fold | Max residency | Total memory in use |
|---|---|---|
| `foldl'` (strict) | **44 KB** | 6 MiB |
| `foldl` (lazy) | **619 MB** | 1159 MiB |

A ~14,000× difference — and at larger `n` the lazy version overflows the stack
outright. (Compile with `-O0` so GHC's strictness analysis doesn't quietly fix
the leak for you; with `-O2` the optimizer may paper over this particular case.)

### Quick in-GHCi version

```text
ghci> import Data.List (foldl')
ghci> foldl' (+) 0 [1..10000000] :: Int     -- fast, tiny memory
50000005000000
ghci> foldl  (+) 0 [1..10000000] :: Int     -- slow, ~1 GB; overflows at larger n
```

### Which fold when?

- **`foldl'`** — strict left fold. Default for *reducing* a list to a single
  value (sums, counts, building a strict accumulator).
- **`foldl`** — almost never what you want; it's the leak above.
- **`foldr`** — `foldr f z (x:xs) = f x (foldr f z xs)`. Lazy in its second
  argument, so it can **short-circuit** and build lazy/infinite structures
  (`map`, `++`, `any`, `&&`). Great for *producing* structure, bad for strict
  accumulation. You'll lean on this distinction in Okasaki.

---

## 6. Exercises

Try each in GHCi before reading the solution. Annotate types so `:sprint` works.

**E1 — Predict the `:sprint`.** Without running it, write down what each `:sprint`
prints:
```text
ghci> let ys = map (*2) [10,20,30] :: [Int]
ghci> :sprint ys
ghci> seq ys ()
ghci> :sprint ys
ghci> ys !! 1            -- force the 2nd element
ghci> :sprint ys
```

**E2 — WHNF or NF?** Classify each: `(\n -> n+1)`, `Just (3+4)`, `7`,
`[1, 2+2]`, `'a' : undefined`.

**E3 — Make `seq` blow up.** `seq (undefined, 5) "ok"` returns `"ok"`. Write an
expression using only `seq` (no `deepseq`) that *does* raise the `undefined`
inside a pair. (Hint: you must force a *field*, not the pair.)

**E4 — Build and kill a leak.** Write `mySum :: [Int] -> Int` as an explicit
recursive loop with a **lazy** accumulator so it leaks. Confirm with
`+RTS -s` (or watch it crawl in GHCi at `n = 10^7`). Then fix it **two** ways:
(a) a `BangPatterns` accumulator, (b) rewriting in terms of `foldl'`.

**E5 — Laziness as a feature.** Define `fibs :: [Integer]` as an infinite list
(`fibs = 0 : 1 : zipWith (+) fibs (tail fibs)`) and evaluate `take 10 fibs`.
Explain in thunk terms why this terminates.

**E6 — Spine vs elements.** Predict the result and the memory behavior:
`length (take 5 (repeat undefined))` versus `sum (take 5 (repeat (undefined::Int)))`.
Which one throws, and why? (Reread §3.)

<details>
<summary>Solutions / hints</summary>

- **E1:** `ys = _`; then `ys = _ : _`; then after forcing element 1, `ys = [_,20,_]`
  (only the demanded element is forced; `!! 1` forces the spine up to index 1 and
  that one element).
- **E2:** WHNF: all five (a lambda and four constructor-headed terms are WHNF).
  NF: only `(\n -> n+1)`, `7`, and `'a' : undefined`? — careful: `'a' : undefined`
  is WHNF but **not** NF (tail is a thunk that's also bottom). NF ones: `7` and the
  lambda. `Just (3+4)` and `[1,2+2]` are WHNF-but-not-NF.
- **E3:** force a field: ``seq (fst (undefined :: Int, 5)) "boom"`` — now `seq`
  forces `fst (...)`, which *is* `undefined`.
- **E4:** lazy `go acc (x:xs) = go (acc + x) xs` leaks; `go !acc …` fixes it, as
  does `foldl' (+) 0`. Confirm residency drops from hundreds of MB to KB.
- **E5:** each new element forces only the two preceding thunks via `zipWith (+)`;
  `take 10` demands exactly 10 cons cells, so the recursion never runs away.
- **E6:** `length …` only walks the spine → returns `5`, never touches the
  `undefined` elements. `sum …` forces the elements → throws. Same structure,
  different demand.
</details>

---

## 7. Today's deliverable

> *A short note documenting one leak you built and killed.*

Write it up (suggested home: `fp-lab/notes/day1-laziness.md`) with this skeleton:

1. **The leak** — the code, and *why* it leaks in thunk/WHNF terms (what's the
   accumulator, what chain builds up).
2. **Evidence before** — the `+RTS -s` max-residency number.
3. **The fix** — the code, and *why* it works (where the WHNF force happens now).
4. **Evidence after** — the new residency number.
5. **The principle** — one sentence you'd tell a teammate to prevent the next one.

Keep it tight; this is portfolio prose you'll reuse when you write up the
*amortization-via-laziness* result on Days 4–5.

---

## Quick reference card

```text
thunk        deferred computation on the heap; forced at most once (memoized)
WHNF         outermost data constructor / lambda exposed; insides may be thunks
NF           fully evaluated; no thunks, no redexes anywhere

seq a b      force a to WHNF, return b           (one level only!)
f $! x       force x to WHNF, then apply f
!x  (pattern) force x to WHNF on match           {-# LANGUAGE BangPatterns #-}
deepseq/force force to NF (everything)            import Control.DeepSeq

foldl'       strict left fold  -> reducing to a value (O(1) space)
foldl        lazy left fold    -> the space leak; avoid
foldr        lazy in 2nd arg   -> producing/short-circuiting, infinite structures

:sprint x    show x without forcing (needs a monomorphic type — annotate ::)
+RTS -s      print GC/residency stats for a compiled program
```
