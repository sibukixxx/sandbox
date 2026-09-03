# 04 WASM / JS バックエンドとインラインテスト

## 学ぶこと

- `moon.pkg` の `pkgtype(kind: "foreign_library")` と `#export_name("...")` 属性で関数をエクスポートする
- 同じソースから `--target wasm-gc` / `js` / `native` にビルドし、Node とブラウザから呼ぶ
- `test { }` を全ターゲットで実行する (`moon test --target js`)
- `inspect` によるスナップショットテスト (`moon test --update`)
- `raise` する関数と `try ... catch ... noraise` によるエラーのテスト

## 実行

```sh
moon test                          # wasm-gc でテスト
moon test --target js              # JS でも同じテスト
moon run cmd/main --target native  # ネイティブで実行

moon build --target js --release && node web/run.mjs            # JS 出力を Node から呼ぶ
moon build --target wasm-gc --release && node web/run-wasm.mjs  # wasm-gc 出力を Node から呼ぶ
ls -l _build/wasm-gc/release/build/core.wasm                    # 生成物のサイズを見る (数百バイト)
```

ブラウザで見るには `python3 -m http.server` でこのディレクトリを配信し、`web/index.html` を開く。

## 期待される出力

```
Total tests: 3, passed: 3, failed: 0.
fib(20) = 6765
sum_to(100) = 5050
```
