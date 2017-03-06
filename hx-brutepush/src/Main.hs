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
    putStrLn ("\n") *> repoNames >>= (>>~ findSrcDirPath sourceDirPaths) >>= (>>~ proceedWith)

repoNames =
    System.Environment.getArgs >>= cmdargs >>= (>>| isrepodir) where
        cmdargs []      = System.Directory.listDirectory dirPathRepos
        cmdargs names   = pure names
        isrepodir name  = System.Directory.doesDirectoryExist$ dirPathRepos </> name

findSrcDirPath [] _ =
    pure Nothing
findSrcDirPath (thisdir:moredirs) reponame =
    System.Directory.doesDirectoryExist (thisdir </> reponame) >>= issrcdir where
        issrcdir False  = findSrcDirPath moredirs reponame
        issrcdir True   = pure$ Just (thisdir </> reponame)

proceedWith Nothing =
    pure ()
proceedWith (Just srcdir) =
    let reponame = System.FilePath.takeFileName srcdir
        repodir = dirPathRepos </> reponame
    in
    putStrLn (repodir ++ "\t:\t" ++ srcdir)

cmdInDir dirpath cmdname cmdargs =
    (System.Process.proc cmdname cmdargs) { System.Process.cwd = dirpath }
