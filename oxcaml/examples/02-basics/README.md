# 02 条件分岐を関数として書く

## 学ぶこと

- `if` / `match` は **式** なので、そのまま関数の戻り値になる
- `function` キーワードで「引数を直接 match する関数」を書く
- `when` ガード、or パターン (`1 | 2 | 3`)、タプルでの複数条件
- バリアント型、`option` と `let*` (Option.bind)
- OxCaml 固有: `exclave_` / `local_` でスタック割り当て、`[@zero_alloc]` で割り当てなしを検査 (コメント内)

## 実行

```sh
dune build && dune exec ./bin/main.exe
```

dune がない場合:

```sh
cd bin && ocamlopt basics.ml main.ml -o ../main && cd .. && ./main
```

## 期待される出力

```
1: 1 / small
2: 2 / small
3: Fizz / small
...
15: FizzBuzz / large
12 0
Some 2
None
asserts ok
```
