# Setup Guide — Haskell toolchain for the two-week trajectory

Written by Claude.

Goal of this step: a working compile/edit/feedback loop you can grow for two weeks
without re-installing anything. Budget ~30 min. Most of it is already done on this
machine — see [Your machine right now](#your-machine-right-now).

## The components

Think of it as **one engine, one map, and several tools that read both**.

| Component | What it is | Role in the loop |
|---|---|---|
| **GHCup** | The toolchain *manager* (like `nvm`/`rustup`, but for Haskell). Lives in `~/.ghcup`. | Installs and switches versions of GHC, Cabal, Stack, and HLS. You run it once; everything below exists because of it. |
| **GHC** | The Glasgow Haskell Compiler + runtime. Also ships `ghci` (the REPL) and the *GHC API* (a library form of the compiler). | The **engine**. Every other tool ultimately calls GHC to parse and typecheck your code. |
| **Cabal** | The build tool and package manager (`cabal-install`). | Reads your `.cabal` file, resolves dependencies from Hackage, and builds with GHC. "Nix-style local builds" = each project gets an isolated, reproducible dependency set, so projects never clobber each other. |
| **Stack** | An *alternative* build tool using curated snapshots. | Installed, but you're standardizing on Cabal. Ignore it. |
| **HLS** | Haskell Language Server — a long-running process speaking the Language Server Protocol (LSP). | The **IDE brain**. Uses the GHC API to give your editor type-on-hover, inline errors, autocomplete, and jump-to-definition. Must match your GHC version. |
| **ghcid** | "GHCi daemon": a tiny watcher that keeps a `ghci`/`cabal repl` session open and recompiles on every save. | The **fast feedback loop** — prints errors in well under a second, the antidote to GHC's slow full compiles during exploration. |
| **VS Code + Haskell ext.** | Your editor and the LSP *client*. | Auto-discovers the GHCup-managed HLS and talks to it over LSP. |
| **Your cabal project** | One package (`.cabal` file) you create now and grow all two weeks. | The **map** everyone reads: a `library` stanza for reusable code (PFDS structures, CT instances), an `executable` for the effectful demo CLI, a `test-suite` for QuickCheck/hedgehog. |

### How they fit together

- **GHCup** sits on top, having installed GHC / Cabal / HLS.
- Your **`.cabal` project** is the single source of truth about modules and deps.
- **Cabal**, **ghcid**, and **HLS** are three consumers of the *same* engine (GHC)
  and the *same* map (your project), each tuned to a different latency:
  - Cabal → full builds and runs (`cabal build`, `cabal run`).
  - ghcid → sub-second recompile-on-save in the terminal.
  - HLS → interactive, in-editor diagnostics and hovers.
- **VS Code** never touches GHC directly; it only talks to **HLS** over LSP.

![Toolchain diagram](./setup-guide.png)

<details>
<summary>Diagram source (Graphviz) — render with <code>dot -Tpng setup-guide.dot -o setup-guide.png</code></summary>

See [`setup-guide.dot`](./setup-guide.dot).
</details>

## Your machine right now

| Component | Status |
|---|---|
| GHCup | installed |
| GHC | `9.4.8` set as active |
| Cabal | `3.16.1.0` |
| Stack | `3.9.3` (present, unused) |
| HLS | `9.4.8~2.14.0.0` present — matches active GHC |
| `ghcid` | **not installed** |
| cabal project | **not created** |

> **GHC version note:** `9.4.8` is a stable choice with a matching HLS already
> installed — stay on it. Every library in the plan (recursion-schemes, criterion,
> QuickCheck, hedgehog, effectful) supports it, so there's no reason to bump.

So only three things remain.

## Step 1 — install ghcid

```sh
cabal update          # refresh the Hackage package index
cabal install ghcid   # compiles from source into ~/.local/bin (or ~/.cabal/bin)
which ghcid           # confirm it's on PATH; if empty, add the printed install dir to PATH
```

## Step 2 — create the one cabal project

Make it inside this folder and grow it for the whole two weeks.

```sh
cd ~/code/learning/learning-haskell/category-theory
cabal init fp-lab \
  --non-interactive \
  --package-name=fp-lab \
  --libandexe --tests \
  --language=GHC2021 \
  --source-dir=src --application-dir=app --test-dir=test \
  --main-is=Main.hs \
  --license=MIT \
  --author="Jonathan Llovet" --email="jonathan.llovet@gmail.com"
```

Resulting layout:

```
fp-lab/
  fp-lab.cabal      # the spine: library + executable + test-suite stanzas
  CHANGELOG.md
  src/MyLib.hs      # library code — rename/grow into Data.PFDS.* etc.
  app/Main.hs       # the executable (your future effectful CLI)
  test/Main.hs      # property tests (QuickCheck / hedgehog)
```

Confirm it builds and runs:

```sh
cd fp-lab
cabal build
cabal run fp-lab     # prints the stub's output
cabal repl           # drops you into ghci with the library loaded
```

As the weeks progress you add dependencies (e.g. `criterion`,
`recursion-schemes`, `QuickCheck`) to the `build-depends` fields in
`fp-lab.cabal` — you never start a fresh project.

## Step 3 — wire up HLS in VS Code

1. Install the **Haskell** extension (`haskell.haskell`) from the Marketplace.
2. On first activation it detects GHCup and uses the managed
   `haskell-language-server-wrapper` from `~/.ghcup/bin` — accept that default
   (`haskell.manageHLS: "GHCup"`).
3. **Open the project root** (the folder containing `fp-lab.cabal`), not the repo
   root — HLS keys off the nearest `.cabal`/`cabal.project`:
   ```sh
   code ~/code/learning/learning-haskell/category-theory/fp-lab
   ```
4. The first open is slow (HLS indexes and builds). After that, hovers and inline
   errors are live.

## Step 4 — verify the loop

- **Cabal:** `cabal build` succeeds.
- **ghcid:** from `fp-lab/`, run `ghcid --command "cabal repl"`. It should print
  `All good`, then re-check in under a second when you save a file.
- **HLS:** in VS Code, hover a value to see its inferred type; introduce a type
  error and confirm a red squiggle appears within a second or two.

When all three react to a saved change, setup is done — start Day 1.
