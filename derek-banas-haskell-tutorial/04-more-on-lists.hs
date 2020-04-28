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