module Main (main) where

import qualified MyLib (someFunc)
import Data.Foldable

main :: IO ()
main = do
  putStrLn "Hello, Haskell!"
  MyLib.someFunc
  mapM_ print [x*x | x <- [1..5 :: Int], odd x]
  traverse_ print [x*x | x <- [1..5 :: Int], even x]
