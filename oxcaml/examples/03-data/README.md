# 03 データ構造とパターンマッチ

## 学ぶこと

- バリアント (列挙、再帰型)、レコード、タプル、`option`
- `let rec` + `function` による再帰的パターンマッチ
- `List.map` / `filter` / `fold_left` / `find_opt`、パイプ `|>`
- `Map.Make` (ファンクタ) でキー型ごとの Map を作る
- `Array` (可変・固定長)
- OxCaml 固有: `float#` (unboxed float)、`#(int * int)` (unboxed タプル) はコメント内

## 実行

```sh
dune build && dune exec ./bin/main.exe
```

dune がない場合: `cd bin && ocamlopt data.ml main.ml -o ../main && cd .. && ./main`

## 期待される出力

```
(1 + 2) * 4 = 12
total: 700
in stock: apple, bread
find bread: qty=2
first: apple
Food: 700
Tool: 0
price range: 100..1500
```
