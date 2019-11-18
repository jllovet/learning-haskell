-- This is an example of a method you would see in imperative programming
-- In particular, this is an example from Java
-- public static int pow2(int n) {
--     x = 1;
--     for (i = 0; i < n; ++i) {
--         x *= 2;
--     }
--     return x;
-- }
-- This can be rewritten as a recursive function or set of functions
pow2 n = pow2loop n 1 0
pow2loop n x i =
    if i < n
        then pow2loop n (x*2) (i+1)
        else x