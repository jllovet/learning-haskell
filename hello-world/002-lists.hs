x = [1,2,3]
empty = []
y = 0 : x -- [0,1,2,3] cons operator : prepends items to a copy of a list
x' = 1 : (2 : (3 : []))
x'' = 1 : 2 : 3 : []

-- Strings are just lists of characters
str = "abcde"
str' = "a" : "b" : "c" : "d" : "e" : []

-- ++ operator is the concatenation operator
-- combines two lists into one
testCombinedList = [1,2,3] ++ [4,5]
combinedList = x'' ++ x''
-- since strings are lists, the concatenator works on them too
dessert = "apple" ++ " " ++ "pie"

-- Lists must be homogeneous
-- That is, they must contain elements all of the same type
-- There is no untyped list or list of <Object>

