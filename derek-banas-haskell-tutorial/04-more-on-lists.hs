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
