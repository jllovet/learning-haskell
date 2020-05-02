import Data.List
import System.IO

{-
When we use :t we get the type signature of functions
For instance:

:t sqrt
sqrt :: Floating a => a -> a

We are going to define the type signature of a custom function in the same way
-}

addMe :: Int -> Int -> Int

{-
addMe is a function that takes an Int as an argument.
That first function returns a function that also takes an Int as an argument.
That second function returns an Int as an output after processing them.
This is like lambda calculus function signatures, except that here we 
are dealing with just the type signatures, instead of the actual
implementation. The implementation will come next.

All implementations will follow this format:

<functionName> [<parameters>] = <expression>

Made a little less general:
funcName param1 param2 = param1 `operation` param2

-}

-- A little less general still:
addMe x y = x + y


{-
As with other built-in functions, we can run :t to get the type of addMe
Doing so will return out declaration from above.
:t addMe
addMe :: Int -> Int -> Int
-}

{-
Functions can also be defined without explicit type signatures.
Haskell will determine the types of the arguments at runtime.
This allows us to write a similar funcion that works with Ints and Floatings
-}

sumMe x y = x + y

sumMe_f_f = sumMe 1.45 2.23 -- 3.6799999999999997
sumMe_i_f = sumMe 1 2.23 -- 3.23
sumMe_i_i = sumMe 1 3 -- 4


addTuples :: (Int, Int) -> (Int, Int) -> (Int, Int)
-- Add tuples elementwise, returning a tuple
addTuples (x1, y1) (x2, y2) = (x1 + x2, y1 + y2)

addTuplesTest = addTuples (1,2) (3,4)


-- Example using different types and illustrating switch
whatAge :: Int -> String
-- Note how defining cases works differently here than in other languages

whatAge 16 = "You can drive! Don't wreck it."
whatAge 18 = "You can vote! Get out there and do it."
whatAge 21 = "You're an adult! Have a beer."

-- Specify default case
whatAge _ = "Nothing important going on."
