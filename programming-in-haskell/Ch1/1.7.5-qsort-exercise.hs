-- qsort exercise

-- This is the first case, as described in the book
-- Programming in Haskell
-- It will produce a sorted list of all of the elements
-- while preserving duplicates of the list
qsort [] = []
qsort (x:xs) = qsort smaller ++ [x] ++ qsort larger
                where
                    smaller = [a | a <- xs, a <= x]
                    larger = [b | b <- xs, b > x]

-- This is the experimental case, where we change the
-- definition of smaller by changing the filter condition
-- to be a < x rather than a <= x
-- Since there is no return specified for the case where 
-- a = x, in those cases, the filter does not return the 
-- element, and it is ultimately not returned in the 
-- smaller list.
-- Consequently, this implementation of qsort produces a 
-- sorted list of the unique elements in the list
qsort' [] = []
qsort' (x:xs) = qsort' smaller ++ [x] ++ qsort' larger
                where
                    smaller = [a | a <- xs, a < x]
                    larger = [b | b <- xs, b > x]