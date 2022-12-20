{ name = "empty-utxos-mre"
, dependencies =
  [ "arrays", "bigints", "cardano-transaction-lib", "datetime", "uint" ]
, packages = ./packages.dhall
, sources = [ "test/**/*.purs" ]
}
