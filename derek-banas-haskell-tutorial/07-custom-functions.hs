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
-}
