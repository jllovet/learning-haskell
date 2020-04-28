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
