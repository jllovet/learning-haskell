"""
The example Haskell sum function sum x y = x + y can be represented in
lambda calculus like so: λx.λy.x+y

λx.λy.x+y is equivalent to the sum function in python below.
"""
def sum(x):
    def sum_1(y):
            return x + y
    return sum_1

x = 1
y = 2
print(sum(x))
# Example value: 
# <function sum.<locals>.sum_1 at 0x7faf50132ca0>

# partial application - which is commonly used in Haskell as well
# Applies only the first argument, returning the inner function definition
partial = sum(x)

# supplying the second argument
result = partial(y)
print(str(result)) # 3


# applying both arguments at once
whole = sum(x)(y)
print(whole) # 3
