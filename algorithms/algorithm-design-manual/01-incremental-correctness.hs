import Data.List
import System.IO

{-
To compile this file, run the following:
ghc --make 01-incremental-correctness.hs

run it:
./01-incremental-correctness
-}

increment :: Int -> Int

increment y = 
    if y == 0
    then 1
        else
            if (y `mod` 2) == 1
            then (2 * increment(y `div` 2))
            -- Need to use `div` because / is not supported for Int type
            else y + 1
