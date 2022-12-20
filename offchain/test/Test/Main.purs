module Test.Main (main) where

import Contract.Prelude

import Contract.Address (addressToBech32, getWalletAddresses)
import Contract.Monad (Contract, launchAff_, liftContractM, liftedE)
import Contract.Log (logInfo')
import Contract.ScriptLookups (ScriptLookups, mkUnbalancedTx)
import Contract.Test.Plutip (runPlutipContract)
import Contract.Transaction (TransactionInput, awaitTxConfirmed, balanceTx, signTransaction, submit)
import Contract.TxConstraints (TxConstraints)
import Contract.TxConstraints as Constraints
import Contract.Utxos (utxosAt)
import Contract.Wallet (withKeyWallet)
import Data.BigInt (fromInt) as BigInt
import Data.Array (head) as Array
import Data.Map (findMin, size) as Map
import Data.Void (Void)
import Test.Config (config)

transaction :: TransactionInput -> Contract () Unit
transaction txIn = do
  let
    lookups :: ScriptLookups Void
    lookups = mempty

    constraints :: TxConstraints Void Void
    constraints = Constraints.mustSpendPubKeyOutput txIn

  logInfo' "Building Tx"
  ubTx <- liftedE $ mkUnbalancedTx lookups constraints

  logInfo' "Balancing Tx"
  bTx <- liftedE $ balanceTx ubTx

  logInfo' "Signing Tx"
  sTx <- signTransaction bTx

  logInfo' "Submitting Tx"
  txId <- submit sTx

  logInfo' $ "Awaiting txId = " <> show txId
  awaitTxConfirmed txId

main :: Effect Unit
main = launchAff_ $ runPlutipContract config [ BigInt.fromInt 5_000_000, BigInt.fromInt 1_000_000_000 ] \alice -> do
  withKeyWallet alice do
    ownAddrs <- getWalletAddresses

    -- Log addresses
    logInfo' <<< show =<< for ownAddrs addressToBech32

    -- Pick first address
    ownAddr <- Array.head ownAddrs # liftContractM "ownAddrs is []"

    utxos <- utxosAt ownAddr
    logInfo' $ "utxos = " <> show (Map.size utxos)

    {key: txIn} <- liftContractM "utxos = []" (Map.findMin utxos)
    transaction txIn
