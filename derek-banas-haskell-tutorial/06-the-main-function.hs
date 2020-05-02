import Data.List
import System.IO

main = do
    putStrLn "What's your name?"
    -- store console input in name
    name <- getLine
    putStrLn ("Hello, " ++ name ++ "!")
