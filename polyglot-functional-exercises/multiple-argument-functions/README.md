## Functions with Multiple Arguments - Nested Function Definitions

In Haskell, there aren’t really functions that take multiple arguments. While you might write some code that looks like that (e.g. `sum x y = x + y`),  this is sugaring for nested functions of the sort used in the lambda calculus. To use the sum function above as an example: this function of two arguments `sum x y` is equivalent to a function of one argument `sum x` that returns a function of one argument `sum y`, where the second function `sum y` has access to the value of the argument `x` through its parent’s scope. 

This approach is pulled from lambda calculus. The basic structure there is `λx.x` (or, put a little more readably `λ<argument>.<body>`). The `<body>` is made up of an expression. In this case, the function `λx.x` is an echo function. Receiving an argument `x`, the return value is `x`. For illustration, another simple function is `λx.x+2`, which, given `x`, will return `x+2`. 

The example Haskell sum function `sum x y = x + y` can be represented in lambda calculus like so: `λx.λy.x+y`

`λx.λy.x+y` is equivalent to the sum function in python below.

```PYTHON
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
```