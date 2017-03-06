module Main where

import Base

import qualified System.Directory
import qualified System.Environment
import qualified System.FilePath
import qualified System.Process


h = "/home/roxor"
hd = h ++ "/dev"
dirPathRepos = h ++ "/git"


sourceDirPaths =
    [ hd ++ "/go/src/github.com/metaleap" , hd ++ "/hs" , hd ++ "/misc" ]
skipCopyingOf =
    [ ".git" , ".stack-work" , "_cache_tmp" , "default-build" ]



main =
    putStrLn ("\n") *> repoNames >>= (>>~ findSrcDirPath) >>= (>>~ proceedWith)

repoNames =
    System.Environment.getArgs >>= cmdargs >>= (>>| isrepodir) where
        cmdargs []      = System.Directory.listDirectory dirPathRepos
        cmdargs names   = pure names
        isrepodir name  = System.Directory.doesDirectoryExist$ dirPathRepos </> name

findSrcDirPath reponame =
    find sourceDirPaths where
        find [] = pure Nothing
        find (thispath:rest) =
            System.Directory.doesDirectoryExist (thispath </> reponame) >>= issrcdir where
                issrcdir False  = find rest
                issrcdir True   = pure$ Just (thispath </> reponame)

proceedWith Nothing =
    pure ()
proceedWith (Just srcdir) =
    let reponame = System.FilePath.takeFileName srcdir
        repodir = dirPathRepos </> reponame
    in
    putStrLn (repodir ++ "\t:\t" ++ srcdir)

cmdInDir dirpath cmdname cmdargs =
    (System.Process.proc cmdname cmdargs) { System.Process.cwd = dirpath }
