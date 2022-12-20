module Test.Config where

import Contract.Prelude

import Contract.Config (emptyHooks)
import Contract.Test.Plutip (PlutipConfig)
import Data.Time.Duration (Seconds(Seconds))
import Data.UInt as UInt

config :: PlutipConfig
config =
  { host: "127.0.0.1"
  , port: UInt.fromInt 8082
  , logLevel: Info
  , customLogger: Nothing
  , suppressLogs: false
  , clusterConfig: { slotLength: Seconds 5.0 }
  , ogmiosConfig:
      { port: UInt.fromInt 1338
      , host: "127.0.0.1"
      , secure: false
      , path: Nothing
      }
  , ogmiosDatumCacheConfig:
      { port: UInt.fromInt 10000
      , host: "127.0.0.1"
      , secure: false
      , path: Nothing
      }
  , postgresConfig:
      { host: "127.0.0.1"
      , port: UInt.fromInt 5433
      , user: "ctxlib"
      , password: "ctxlib"
      , dbname: "ctxlib"
      }
  , kupoConfig:
      { host: "127.0.0.1"
      , port: UInt.fromInt 1442
      , secure: false
      , path: Nothing
      }
  , hooks: emptyHooks
  }
