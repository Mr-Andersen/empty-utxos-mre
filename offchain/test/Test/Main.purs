module Test.Main (main) where

import Contract.Prelude

import Contract.Address (addressToBech32, getWalletAddresses)
import Contract.Monad (launchAff_, liftContractM)
import Contract.Log (logInfo')
import Contract.Test.Plutip (runPlutipContract)
import Contract.Utxos (utxosAt)
import Contract.Wallet (withKeyWallet)
import Data.BigInt (fromInt) as BigInt
import Data.Array (head) as Array
import Test.Config (config)

main :: Effect Unit
main = launchAff_ $ runPlutipContract config [ BigInt.fromInt 5_000_000, BigInt.fromInt 1_000_000_000 ] \alice -> do
  withKeyWallet alice do
    ownAddrs <- getWalletAddresses

    -- Log addresses
    logInfo' <<< show =<< for ownAddrs addressToBech32

    -- Pick first address
    ownAddr <- Array.head ownAddrs # liftContractM "ownAddrs is []"

    utxos <- utxosAt ownAddr
    logInfo' $ "utxos = " <> show utxos
