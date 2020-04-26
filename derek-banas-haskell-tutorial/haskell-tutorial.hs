{-

******************************
Getting started
see: http://learnyouahaskell.com/introduction#about-this-tutorial
******************************

At a terminal, type ghci to open a Haskell REPL
:l <haskell-file> will load in a Haskell file to your session

For example:
ghci
:l haskell-tutorial

:r will run everything in the file that is currently loaded

******************************
Comment Syntax
******************************

-- Single line comments are started with double dashes

{- 
Multiline comments use curly braces and dashes
-}

-}

-- Module imports
import Data.List
import System.IO

{-

******************************
Types!
******************************

Haskell uses type inference, which means that it will guess a variable's
type based on the value that is stored inside of it.

Haskell is statically typed. Once a variable's type is assigned, it cannot be
changed.

-}

-- Some built-in types:

{-
******************************
Int
******************************
Bounded Whole Number

Minimum value: -2^63 - 1
Maximum value: 2^63
Checking bounds of Int:
maxBound :: Int
minBound :: Int
-}

maxInt = maxBound :: Int
-- maxInt == 9223372036854775807

minInt = minBound :: Int
-- minInt == -9223372036854775808


{-
******************************
Integer
******************************

Unbounded whole number
Holds numbers as large as memory can handle

-}


{-
******************************
Float
******************************

Single-precision floating-point numbers

-}


{-
******************************
Double
******************************

Floating-point numbers with precision up to 11 points

-}

bigDouble = 3.99999999999
worksFine = bigDouble + 0.00000000005
biggerDouble = 3.999999999999
doesntWork = bigDouble + 0.000000000009


{-
******************************
Bool
******************************

Booleans with values True or False
Operators:

    and             &&
    or              ||
    negation        not
    equality        ==
    inequality      /=

-}


{-
******************************
Char
******************************

Single Unicode characters
Marked by single quote. E.g, 'a'

-}

{-
******************************
Tuple
******************************

Use Parentheses
Can store multiple data types

-}

-- Types can be explicitly declared using ::

always5 :: Int
always5 = 5

{-
Inside of ghci, we can run 
:t always5

Which will return
always5 :: Int
-}



{-
******************************
List
******************************

Use square brackets
Can only store elements with the same data type
For example, these are legal:
[1,2,3,4]
['a', 'b', 'c']

While this is not legal:
[1,2,'a','b']


Lists can generate values in an arithmetic sequence specified in a range

Ints:
[1..100]

Chars:
['a'..'z']

You can also specify the step between elements by enumerating the first
few elements before the .. operator.

To get every second element in the range 1 - 100
[1,3..100]

-}

ints = [1..100]
chars = ['a'..'z']
everyTwo = [1,3..100]
everyHundred = [0,100..10000]

-- These can be combined with functions for really powerful expressions

sumOfNums = sum everyHundred

{-
******************************
Operator Placement
******************************

We are used to seeing common operators in mathematics as infix operators,
placed between their arguments.

For instance, with the operator +
4 + 5

In Haskell, operators (which really are just functions) can be placed before
or between their operands. However, when placing an operator between two
arguments, it needs to have backticks.

-}

-- Prefix operator (normal function placement)
modExpression = mod 5 4

-- Infix operator
modExpression1 = 5 `mod` 4


-- Negative numbers need to be wrapped in parentheses when following an operator

-- This will throw an error
-- negativeNumAfter = 5 + -4

-- Valid
negativeNumAfter = 5 + (-4)

-- But if they are not following an operator, then they do not need parentheses
negativeNumFirst = -3 + 2
