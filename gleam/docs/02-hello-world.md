# 02. Hello, World

対応サンプル: [`examples/01-hello-world/`](../examples/01-hello-world/)

## 目的

`gleam new` の構成と、同じコードが Erlang と JavaScript で動くことを確認する。

## 最小コード

```
01-hello-world/
├── gleam.toml           # 名前、バージョン、依存
├── manifest.toml        # ロックファイル
├── src/hello.gleam      # プロジェクト名と同じモジュールの main が入口
└── test/hello_test.gleam
```

```gleam
import gleam/io

pub fn main() -> Nil {
  io.println("Hello, World!")
}
```

## 実行

```sh
gleam run
gleam run --target javascript
```

期待される出力:

```
Hello, World!
```

## 解説

| 要素 | 意味 |
|---|---|
| `import gleam/io` | 標準ライブラリ (`gleam_stdlib`) のモジュール。`io.println` で参照 |
| `pub fn main() -> Nil` | `pub` で公開。`Nil` は「意味のある値を返さない」型 |
| `gleam run` | `src/<プロジェクト名>.gleam` の `main` を実行する |

`gleam.toml` の `[dependencies]` に `gleam_stdlib` があり、`gleam run` が初回に Hex から取得する。

## 他の言語ではこう書く

Elixir の `IO.puts` と同じことをしているが、Gleam は静的型なので `io.println(42)` はコンパイルエラー (`int.to_string` が要る)。

## 落とし穴

- `main` は `pub` でないと `gleam run` から見えない。
- 文字列連結は `<>`。`+` は数値専用。
