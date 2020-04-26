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
