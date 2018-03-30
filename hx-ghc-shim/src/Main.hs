module Main where

import qualified System.Directory
import qualified System.Environment
import qualified System.IO
import qualified System.Process

main :: IO ()
main =
    System.Environment.getArgs >>= \ cmdargs
    -> System.IO.hFlush System.IO.stdout
    *> System.Directory.getCurrentDirectory >>= \ curdir
    -> System.IO.hFlush System.IO.stdout
    *> putStrLn "CURDIR:"
    *> System.IO.hFlush System.IO.stdout
    *> putStrLn curdir
    *> System.IO.hFlush System.IO.stdout
    *> putStrLn "GHC-ARGS:"
    *> System.IO.hFlush System.IO.stdout
    *> print cmdargs
    *> System.IO.hFlush System.IO.stdout
    *> putStrLn "GHC-FWD:"
    *> System.IO.hFlush System.IO.stdout
    *> System.Process.callProcess "hx-ghc-real" cmdargs
    *> System.IO.hFlush System.IO.stdout
