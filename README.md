## Empty UTxOs in `runPlutipContract`

### Running with `nix`

```shell
nix build .#checks.x86_64-linux.empty-utxos-mre -L --no-link
```

### Running with `spago`

```shell
nix develop .#offchain
cd offchain
spago run -m Test.Main
```

## Result

```
[INFO] 2022-12-20T10:34:57.603Z ["addr1vy39dmxv3myyxa9ezmuk660z7u9m49p3vnl2287tq05k7ncgrh875"]
[INFO] 2022-12-20T10:34:57.610Z utxos = (fromFoldable [])
```

### Expected

`utxos` (2nd line in log) should contain two UTxOs

### Actual

`utxos` are empty
