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

`mkUnbalancedTx` call fails:

```
[INFO] 2022-12-20T11:17:46.118Z ["addr1vyy7064uv5fmqjqsx6y9l28enxppjz8gm6dvmr2zt2c50ggnv8943"]
[INFO] 2022-12-20T11:17:46.129Z utxos = 2
[INFO] 2022-12-20T11:17:46.129Z Building Tx
/home/aka_dude/Work/mlabs/empty-utxos-mre/offchain/output/Effect.Aff/foreign.js:532
                throw util.fromLeft(step);
                ^

Error: (TxOutRefNotFound (TransactionInput { index: 0u, transactionId: (TransactionHash (hexToByteArrayUnsafe "b7961a913db910376fa4e3a586b06d943307d767a2f9e33cd138d5c8b4fa0343")) }))
    at Object.exports.error (/home/aka_dude/Work/mlabs/empty-utxos-mre/offchain/output/Effect.Exception/foreign.js:8:10)
    at Object.$$throw [as throw] (/home/aka_dude/Work/mlabs/empty-utxos-mre/offchain/output/Effect.Exception/index.js:18:45)
    at /home/aka_dude/Work/mlabs/empty-utxos-mre/offchain/output/Contract.Monad/index.js:179:45
    at /home/aka_dude/Work/mlabs/empty-utxos-mre/offchain/output/Data.Either/index.js:203:24
    at /home/aka_dude/Work/mlabs/empty-utxos-mre/offchain/output/Control.Monad.Reader.Trans/index.js:108:34
    at run (/home/aka_dude/Work/mlabs/empty-utxos-mre/offchain/output/Effect.Aff/foreign.js:278:22)
    at /home/aka_dude/Work/mlabs/empty-utxos-mre/offchain/output/Effect.Aff/foreign.js:348:19
    at drain (/home/aka_dude/Work/mlabs/empty-utxos-mre/offchain/output/Effect.Aff/foreign.js:120:9)
    at Object.enqueue (/home/aka_dude/Work/mlabs/empty-utxos-mre/offchain/output/Effect.Aff/foreign.js:141:11)
    at /home/aka_dude/Work/mlabs/empty-utxos-mre/offchain/output/Effect.Aff/foreign.js:339:27
[error] Running failed; exit code: 1
```
