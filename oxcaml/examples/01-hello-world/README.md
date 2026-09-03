# 01 Hello, World

## 学ぶこと

- `dune-project` / `bin/dune` / `bin/main.ml` の最小構成
- `let () = ...` でトップレベルの副作用を書く
- 標準 OCaml のコードが OxCaml でそのまま動くことを確認する

## 実行

```sh
eval $(opam env --switch 5.2.0+ox --set-switch)   # OxCaml switch を有効化
dune build && dune exec ./bin/main.exe
```

dune がない場合はコンパイラを直接呼んでもよい:

```sh
ocamlfind ocamlopt -package unix bin/main.ml -o hello && ./hello
```

## 期待される出力

```
Hello, World!
```
