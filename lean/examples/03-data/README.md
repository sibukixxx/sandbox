# 03 データ構造とパターンマッチ

## 学ぶこと

- `inductive` (列挙・再帰型) / `structure` / `deriving Repr, BEq, DecidableEq`
- `.num n` のような省略記法と、引数を直接パターンマッチする再帰関数
- `List` の `map` / `filter` / `foldl` / `find?`、`|>.` パイプ
- リストパターン `head :: _`、`Option`
- 具体値の性質は `by decide`、一般の性質は `theorem` で証明する

## 実行

```sh
lake build && lake exe data
```

## 期待される出力

```
(1 + 2) * 4 = 12
total: 700
in stock: [apple, bread]
find bread: some { name := "bread", price := 200, qty := 2, category := Category.food }
by category: [(Category.food, 700), (Category.tool, 0)]
```
