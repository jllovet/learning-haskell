-- head function returns the first element of the list
a = head [1,2,3]
-- tail function returns all but the first element of the list
b = tail [1,2,3]

-- These two functions can be combined to access any element
numbers = [1,2,3,4]
case1 = head (tail numbers)
-- returns 2
case2 = head (tail (tail numbers))
-- returns 3

-----------------------------------------------
-- null function tests whether a list is empty
empty_list_check1 = null []
-- returns True

empty_list_check2 = null [1,2]
-- returns False

-----------------------------------------------
-- function to double each of the elements of a list
double nums = 
    if null nums
        then []
        else (2 * (head nums) : (double (tail nums)))

-- For example:
    -- numbers = [1,2,3,4]
    -- double numbers
    -- returns: [2,4,6,8]
