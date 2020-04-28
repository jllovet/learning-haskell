import Data.List
import System.IO
{-
Lists

Lists in Haskell are singly linked

Here are some examples building on what is in 01-basic-data-types

-}

primeNumbers = [3,5,7,11]

morePrimes = primeNumbers ++ [13,17,19,23,29]

favNums = 2 : 7 : 21 : 66 : []

nestedLists = [[3,5,7] , [11,13,17]] -- contains multiple lists

morePrimes2 = 2 : morePrimes

lenPrimes = length morePrimes2

revPrimes = reverse morePrimes2

isListEmpty = null morePrimes2 -- will return False

-- To access specific indices, <list> !! <index>

fourthItem = morePrimes2 !! 3

firstPrime = head morePrimes2

lastPrime = last morePrimes2

initPrimes = init morePrimes2 -- returns all but last element of list

first3Primes = take 3 morePrimes2

removedPrimes = drop 3 morePrimes2 -- returns list after the n elements specified

letters = take 5 (drop 10 ['a'..'z'])
-- letters 
-- "klmno"

is7ElementOfList = 7 `elem` morePrimes2

alternativeIs7ElementOfList = elem 7 morePrimes2

maxPrime = max morePrimes2

minPrime = min morePrimes2

mySum = sum [1,2,3,4,5] -- 15

myProduct = product [1,2,3,4,5] -- 120

-- Other uses cases for generated lists
greeksConverted = ['α'..'ω']
-- "\945\946\947\948\949\950\951\952\953\954\955\956\957\958\959\960\961\962\963\964\965\966\967\968\969"
greeks = putStrLn ['α'..'ω']
-- αβγδεζηθικλμνξοπρςστυφχψω

-- see https://stackoverflow.com/questions/14039726/how-to-make-haskell-or-ghci-able-to-show-chinese-characters-and-run-chinese-char


many2s = take 10 (repeat 2)

-- similarly

many3s = replicate 10 3

cycleList = take 10 (cycle [1..4])


-- List comprehensions

someList = [1..10]
doubleAllElements y = [x * 2 | x <- y]
sumDoubleElements y = sum (doubleAllElements y)
anotherSum = sumDoubleElements someList

-- Filtering list comprehensions

doubleElementsFiltered y threshold = [x * 4 | x <- y, x * 4 <= threshold]

-- After list comprehension, add a boolean test for inclusion

testList = doubleElementsFiltered [1..100] 200

-- Checking divisibility

specials = [x | x <- [1..500], mod x 2 == 0, mod x 3 == 0, mod x 7 == 0]


-- Doesn't work. Look into how to generate multiple filters from a function

-- modChecks x divisors = [mod x divisor == 0 | divisor <- divisors]
-- nums = [2,3,7]
-- specials' = [x | x <- [1..500], modChecks x nums]
-- specials'

sortedList = sort [6846,9,1,3,7,35,4,687,351,687,351,684]

-- Zipping lists

sumZippedList = zipWith (+) [1,2,3,4,5] [3,4,4,2,1]
sumZippedList' = zipWith (+) [1,2,3,4,5] [3,4,4,2]
-- will only return a list with the elements it was able to zip
-- sumZippedList'
-- [4,6,7,6]

-- Approaches to filtering
listBiggerThan5 = filter (>5) morePrimes

evensUpTo20 = takeWhile (<=20) [2,4..] -- using an infinite list!

-- Folding over a list
folder = foldl (*) 1 [1..10] -- returns 10 factorial!!

folder' = foldl (-) 1 [1..10]
-- returns: -54

-- But foldr, which iterates over elements in reverse:
folder'' = foldr (-) 1 [1..10]
-- returns -4


-- More on list comprehension
pow3List = [3^n | n <- [1..10]]

-- equivalent to the following in python:
-- pow3List = [3**num for num in range(1,11)]

-- Multiple lists can be fed into the list comprehension in Haskell

-- Creates a two-dimensional list
multTable = [[x * y
            | y <- [1..10]]
            | x <- [1..10]]
