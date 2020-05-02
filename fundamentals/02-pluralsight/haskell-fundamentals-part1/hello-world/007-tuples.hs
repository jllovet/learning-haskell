-- Tuples can contain elements of multiple types, while lists cannot.
-- Example list:
list = [1,2,3,4]
-- Example tuple:
x = (1, "hello")

-- Another example tuple with several types
y = ("pi", 3.14159, [1,2,3], "four")

-- However, a list has dynamic length, while a tuple has a fixed length

-- Tuples are often used to effectively return multiple values from a function
headAndLength list = (head list, length list)

-- These functions access elements of the tuple
-- fst - accesses the first element
-- snd - accesses the second element

-- a = (1, "hello")

-- fst a
-- returns: 1

-- snd a
-- returns: "hello"

-- If tuples are more than about 3 elements long, the code becomes fragile
-- and difficult to maintain. Instead of long tuples, custom data types are
-- recommended.
