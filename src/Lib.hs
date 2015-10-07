{-# LANGUAGE StandaloneDeriving #-}

module Lib where

import System.IO.Unsafe

import GHC
import GHC.Paths

import Name
import Module
import Outputable
import BasicTypes (Fixity(..), FixityDirection(..))
import DynFlags (Language(..))

import Documentation.Haddock

import Text.Show.Pretty (ppShow)

getDFlags = runGhc (Just libdir) $ getSessionDynFlags

dflags = unsafePerformIO getDFlags

oshow ctor val = ctor ++ " \"" ++ showSDoc dflags (ppr val) ++ "\""

instance Show Name where
  show = oshow "Name"

instance Show Module where
  show = oshow "Module"

instance Show OccName where
  show = oshow "OccName"

instance Show ModuleName where
  show = oshow "ModuleName"

deriving instance Show FixityDirection
deriving instance Show Language
deriving instance Show Fixity
deriving instance Show a => Show (HaddockModInfo a)
deriving instance Show InstalledInterface
deriving instance Show InterfaceFile

test path = do
  dflags <- getDFlags
  let pshow :: Outputable a => a -> String
      pshow a = "\"" ++ showSDoc dflags (ppr a) ++ "\""
  r <- readInterfaceFile freshNameCache path
  case r of
    Left e      -> putStrLn $ "error: " ++ e
    Right iface -> putStrLn $ ppShow iface

