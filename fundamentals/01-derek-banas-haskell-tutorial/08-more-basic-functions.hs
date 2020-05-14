import Data.List
import System.IO

-- Naive factorial function
-- Nota bene: Overflows Int at factorial 49
factorial :: Int -> Int

factorial 0 = 1
factorial n = n * factorial (n-1)

-- Guard pattern

isOdd n
    | n `mod` 2 == 0 = False
    | otherwise = True
