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
-- zip ([1,4..100]) (map letterGrade [1,4..100])

-- Remove repetitions of calculations by defining calculations in where clause

batAvgRating :: Double -> Double -> String
batAvgRating hits atBats
    | avg <= 0.200 = "No bueno."
    | avg <= 0.250 = "Decent, about average."
    | avg <= 0.280 = "Wow. Pretty good."
    | otherwise = "Amazing."
    where avg = hits / atBats

getListItems :: [Int] -> String

getListItems [] = "Your list is empty."
getListItems (x:[]) = "Your list starts with " ++ show x
getListItems (x:y:[]) = "Your list contains " ++ show x ++ " and " ++ show y
getListItems (x:xs) = "Your starts with " ++ show x ++ " and then " ++ show xs

-- 'As' pattern TODO: Research other applications
getFirstLetter [] = "Empty String"
getFirstLetter all@(x:xs) = "The first letter in " ++ all ++ " is " ++ [x]
