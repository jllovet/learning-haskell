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

isEven n = not (isOdd n)

-- Gaurd pattern is analogous to a switch statement in other languages

letterGrade :: Int -> String

letterGrade numberGrade
    | numberGrade >= 95 = "A"
    | numberGrade >= 90 = "B"
    | numberGrade >= 80 = "C"
    | numberGrade >= 70 = "D"
    | otherwise = "F"

-- Create a list that contains tuples with each letter and number grade
-- at four point intervals up to 100
zip ([1,4..100]) (map letterGrade [1,4..100])
