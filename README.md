# Learning Haskell
This repo is to centralize resources, projects, notes, and exercises for learning Haskell. My hope is that if I keep track of what I do while learning it, someone else might find some use in it to explore Haskell and functional programming themselves.

# Installation
Instructions for installing Haskell can be found here: [haskell.org](https://www.haskell.org/)

# Quick Start
After you have finished the installation, here are some ways to get your feet wet right away. (Examples adapted from [haskell.org](https://www.haskell.org/))

```HASKELL
23 * 36
```
```HASKELL
reverse "hello"
```
```HASKELL
foldr (:) [] [1,2,3]
```
```HASKELL
:t 23
```
```HASKELL
:t (+)
```

## Example Function - Prime Generator

*WATCH OUT:* Since Haskell is lazily evaluated, the line `filterPrime [2..]` will create a generator that will potentially run indefinitely. 

Unless you want that, (which you probably don't) don't call `primes` in the following block without `take n` where `n` is some positive integer.

(If you run it anyway, then use a keyboard interrupt (`ctr+D`) to stop it when you've had your fill of watching the world burn. If that doesn't work, then force quit your shell.)

```HASKELL
filterPrime (p:xs) = p : filterPrime [x | x <- xs, x `mod` p /= 0]
primes = filterPrime [2..]
take 10 primes
```
As noted on the original example at [haskell.org](https://www.haskell.org/), this is not to be taken as a serious prime number generator, but rather as an illustration of some of Haskell's features.

# Resources
Books, videos, blog posts, and other materials useful for learning Haskell and related topics will be added in [/resources](https://github.com/Jonathan-Llovet/learning-haskell/resources).
