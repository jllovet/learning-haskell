-- pow2 n = 2 to the power n
pow2 n = 
    if n == 0
        then 1
        else 2 * (pow2 (n-1))

-- This is equivalent to the following in iterative programming 
-- int pow2 (int n) {
--     int x = 1;
--     for ( int i = 0; i < n; ++i ) {
--         x *= 2;
--     }
--     return x;
-- }