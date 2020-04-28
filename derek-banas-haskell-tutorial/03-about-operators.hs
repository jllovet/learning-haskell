{-
As with functions and variables, you can get information about 
operators by using :t

:t (+)
(+) :: Num a => a -> a -> a

This operator takes two values and returns another value

More properly, it is a function of one (the first) argument that returns 
a function of another (the second) argument.

More information about functions can be obtained by using the :info function

info: (+)
class Num a where
  (+) :: a -> a -> a
  ...
  	-- Defined in ‘GHC.Num’
infixl 6 +


Another example, the truncate function:

:t truncate 
truncate :: (RealFrac a, Integral b) => a -> b

-}
