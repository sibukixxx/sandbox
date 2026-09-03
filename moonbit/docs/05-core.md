# 05. WASM / JS バックエンドとインラインテスト

対応サンプル: [`examples/04-core/`](../examples/04-core/)

## 目的

同じソースを WASM と JS に出力してホストから呼ぶ手順と、MoonBit のテスト機能を一通り使う。

## 最小コード

```
// moon.pkg
import { "moonbitlang/core/strconv" }
pkgtype(kind: "foreign_library")
options("link": { "js": { "format": "esm" } })
```

```moonbit
#export_name("fib")
pub fn fib(n : Int) -> Int {
  if n < 2 { n } else { fib(n - 1) + fib(n - 2) }
}

test "fib" {
  assert_eq(fib(10), 55)
}
```

```sh
moon build --target wasm-gc --release   # → _build/wasm-gc/release/build/core.wasm
moon build --target js --release        # → _build/js/release/build/core.js
```

## 解説

### バックエンド

| target | 出力 | 用途 |
|---|---|---|
| `wasm-gc` (既定) | `.wasm` (GC 提案を使用) | ブラウザ (Chrome 119+, Firefox 120+)、Node 22+ |
| `wasm` | `.wasm` (GC なし、線形メモリ) | 古いランタイム、WASI |
| `js` | `.js` (ESM / CJS) | Node、バンドラ |
| `native` | 実行ファイル (C 経由) | CLI、サーバ |

`moon run` / `moon test` / `moon build` に `--target` を付けるだけで切り替わる。サンプルの `fib` は wasm-gc で **数百バイト** になる。

### エクスポート

- `pkgtype(kind: "foreign_library")`: このパッケージ単体で成果物を作る
- `#export_name("fib")`: ホストから見える名前を付ける。`pub` かつ非ジェネリックな関数に限る
- JS 側は `import { fib } from "./core.js"`、WASM 側は `instance.exports.fib`

wasm-gc の出力は `println` のために `spectest.print_char` インポートを要求する。ホスト側で渡す。

### テスト

| 機能 | 書き方 |
|---|---|
| 単体テスト | `test "name" { assert_eq(a, b) }` |
| スナップショット | `inspect(x, content="...")`。`moon test --update` で `content` を自動生成 |
| エラーのテスト | `try f() catch { e => ... } noraise { _ => fail("...") }` |
| 別ターゲット | `moon test --target js` / `native` |
| ブラックボックス | `*_test.mbt` は外部からの API テスト。`*_wbtest.mbt` は内部アクセス可 |

テストがソースと同じファイルに書け、全ターゲットで同じテストが走る。「WASM では動かない」を早期に見つけられる。

## 他の言語ではこう書く

Rust で WASM を出すには `wasm-bindgen` と `wasm-pack` が要り、JS との型変換を自分で書く。MoonBit は `#export_name` だけで済む (ただし引数は数値などの単純型が中心)。
Rust の `#[test]` も同じファイルに書けるが、`cargo test` は常にホストで走る。

## 落とし穴

- `try?` は非推奨 (deprecated)。`try ... catch ... noraise` を使う。
- `@strconv` など core のサブパッケージは `moon.pkg` で import しないと警告になる。
- `moon build` の既定は debug。成果物のパスは `_build/<target>/debug/...` で、`--release` を付けると `release/`。
- エラーメッセージには行番号が入るので、スナップショットではエラーの種類 (`e is Failure(_)`) だけを検査する。
