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

`awaitTxConfirmed` call fails:

```
/home/aka_dude/Work/mlabs/empty-utxos-mre/offchain/output/Effect.Aff/foreign.js:532
                throw util.fromLeft(step);
                ^

Error: (AtKey "result" (TypeMismatch "Record.TxNotFound"))
    at Object.exports.error (/home/aka_dude/Work/mlabs/empty-utxos-mre/offchain/output/Effect.Exception/foreign.js:8:10)
    at dispatchErrorToError (/home/aka_dude/Work/mlabs/empty-utxos-mre/offchain/output/Ctl.Internal.QueryM.Dispatcher/index.js:97:33)
    at /home/aka_dude/Work/mlabs/empty-utxos-mre/offchain/output/Data.Bifunctor/index.js:31:49
    at __do (/home/aka_dude/Work/mlabs/empty-utxos-mre/offchain/output/Ctl.Internal.QueryM/index.js:371:161)
    at __do (/home/aka_dude/Work/mlabs/empty-utxos-mre/offchain/output/Ctl.Internal.QueryM/index.js:769:78)
    at func (/home/aka_dude/Work/mlabs/empty-utxos-mre/offchain/output/Ctl.Internal.JsWebSocket/foreign.js:64:12)
    at ReconnectingWebSocket._callEventListener (/nix/store/nafi453gpd4jzc8n4fzz10gfm03vc04m-node-dependencies-empty-utxos-mre-pab-0.1.0/lib/node_modules/reconnecting-websocket/dist/reconnecting-websocket-cjs.js:557:13)
    at /nix/store/nafi453gpd4jzc8n4fzz10gfm03vc04m-node-dependencies-empty-utxos-mre-pab-0.1.0/lib/node_modules/reconnecting-websocket/dist/reconnecting-websocket-cjs.js:176:81
    at Array.forEach (<anonymous>)
    at NoPerMessageDeflateWebSocket.ReconnectingWebSocket._handleMessage (/nix/store/nafi453gpd4jzc8n4fzz10gfm03vc04m-node-dependencies-empty-utxos-mre-pab-0.1.0/lib/node_modules/reconnecting-websocket/dist/reconnecting-websocket-cjs.js:176:38)
[error] Tests failed: exit code: 1
```
