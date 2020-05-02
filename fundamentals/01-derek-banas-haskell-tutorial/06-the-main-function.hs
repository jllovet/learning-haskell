import Data.List
import System.IO

{-
To compile this file, run the following:
ghc --make 06-the-main-function.hs

run it:
./06-the-main-function
-}

main = do
    putStrLn "What's your name?"
    -- store console input in name
    name <- getLine
    putStrLn ("Hello, " ++ name ++ "!")
