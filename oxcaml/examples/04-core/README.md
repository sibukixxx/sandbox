# 04 モード (local / unique) と unboxed 型

## 学ぶこと

- `local_` / `exclave_`: スタック割り当てと、ローカルな値のエスケープ検査
- `[@zero_alloc]`: 「この関数はヒープ割り当てをしない」をコンパイラに検査させる
- `unique_`: 一意な所有と in-place 更新
- `float#` / `#(int * int)`: unboxed 型で割り当てを減らす
- 標準 OCaml との互換性 (モードを付けない部分はそのまま)

## 実行

OxCaml switch が必要。

```sh
eval $(opam env --switch 5.2.0+ox --set-switch)
dune build && dune exec ./bin/main.exe
```

## 期待される出力

```
use_local = 3
(3, 4)
clamp = 10
min_max = (2, 9)
dot = 5.000000
divmod = (3, 2)
overwrite = 0
```

## 動作確認

- **未確認**。このリポジトリを作成した環境では OxCaml コンパイラのソース取得ができなかった (プロキシで 403)。
  構文は https://oxcaml.org/documentation/ に基づく。OxCaml switch で確認したら日付と `ocaml -version` の出力をここに記す。

## 試してみる

- `use_local` の中で `p` を返すように変えると `local value escapes its region` エラーになる
- `clamp` の中でタプルを作ると `[@zero_alloc]` の検査で失敗する
- `overwrite r1` の後に `!r1` を使うと `unique` の検査で失敗する
