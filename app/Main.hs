module Main where

import qualified Lib
import System.Environment

main :: IO ()
main = do
  (path : _) <- getArgs
  Lib.test path

