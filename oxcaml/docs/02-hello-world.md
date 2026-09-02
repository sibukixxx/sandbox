# 02. Hello, World

対応サンプル: [`examples/01-hello-world/`](../examples/01-hello-world/)

## 目的

OxCaml が標準 OCaml の上位互換であることを、標準 OCaml のコードで確認する。dune プロジェクトの最小構成を知る。

## 最小コード

```
01-hello-world/
├── dune-project      # (lang dune 3.0)
└── bin/
    ├── dune          # (executable (name main))
    └── main.ml
```

```ocaml
let () = print_endline "Hello, World!"
```

## 実行

```sh
eval $(opam env --switch 5.2.0+ox --set-switch)
dune build && dune exec ./bin/main.exe
```

dune がなければ `ocamlopt bin/main.ml -o hello && ./hello`。

期待される出力:

```
Hello, World!
```

## 解説

| 要素 | 意味 |
|---|---|
| `let () = ...` | トップレベルで副作用を実行する慣用句。`()` に unit をパターンマッチしている |
| `print_endline` | 改行付き出力。`Printf.printf` もある |
| `dune-project` | プロジェクトルートの印と dune のバージョン |
| `bin/dune` | このディレクトリに実行ファイル `main` があることを宣言 |

OxCaml は `opam switch` として提供される。switch を切り替えるだけで、同じソースを標準 OCaml と OxCaml の両方でビルドできる。

## 他の言語ではこう書く

Rust の `fn main()` に相当するものはなく、トップレベルの `let () = ...` が上から順に実行される。

## 落とし穴

- OxCaml switch の作成 (`opam switch create 5.2.0+ox ...`) にはコンパイラのビルドが必要で、数十分かかる。
- OxCaml 固有の構文 (`local_`, `unique_`, `float#`) を使ったファイルは標準 OCaml ではコンパイルできない。互換性を保ちたい部分と分ける。
