# 02. Hello, World

対応サンプル: [`examples/01-hello-world/`](../examples/01-hello-world/)

## 目的

MoonBit の「モジュール」と「パッケージ」の 2 層構造を知り、同じコードを WASM と JS で動かす。

## 最小コード

```
01-hello-world/
├── moon.mod              # モジュール定義
└── cmd/main/
    ├── moon.pkg          # パッケージ定義 (executable)
    └── main.mbt
```

```
// moon.mod
name = "learn/hello"
version = "0.1.0"
preferred_target = "wasm-gc"
```

```
// cmd/main/moon.pkg
pkgtype(kind: "executable")
```

```moonbit
// cmd/main/main.mbt
fn main {
  println("Hello, World!")
}
```

## 実行

```sh
moon run cmd/main                  # wasm-gc で実行
moon run cmd/main --target js      # JS で実行
moon run cmd/main --target native  # ネイティブで実行
```

期待される出力:

```
Hello, World!
```

## 解説

| 要素 | 意味 |
|---|---|
| `moon.mod` | **モジュール** = 配布単位 (npm の package に相当)。`name` が全パッケージのパス接頭辞になる |
| `moon.pkg` | **パッケージ** = ディレクトリ単位のコンパイル単位。ディレクトリごとに 1 つ置く |
| `pkgtype(kind: "executable")` | このパッケージが `fn main` を持つ実行ファイルであることを示す |
| `fn main { }` | エントリポイント。引数も戻り値もない |

`moon new` で生成すると `.githooks/` や `README.mbt.md` なども付くが、最小構成は上の 3 ファイル。

## 他の言語ではこう書く

Rust の `Cargo.toml` + `src/main.rs` に近いが、MoonBit はディレクトリごとに `moon.pkg` を置く点が Go のパッケージに似ている。

## 落とし穴

- 2025 年以前の記事は `moon.mod.json` / `moon.pkg.json` (JSON 形式) を使っている。現在のツールチェインは `moon.mod` / `moon.pkg` を生成する。
- `moon run` にはパッケージのディレクトリを渡す (`moon run cmd/main`)。ファイルではない。
