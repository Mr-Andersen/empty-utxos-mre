{ name = "empty-utxos-mre"
, dependencies =
  [ "arrays"
  , "bigints"
  , "cardano-transaction-lib"
  , "datetime"
  , "ordered-collections"
  , "prelude"
  , "uint"
  ]
, packages = ./packages.dhall
, sources = [ "test/**/*.purs" ]
}
