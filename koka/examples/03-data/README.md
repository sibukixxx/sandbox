# 03 データ構造とパターンマッチ

## 学ぶこと

- `type` (列挙・再帰型) と `struct` (フィールドがアクセサ関数になる)
- `match` による再帰的パターンマッチ。停止性は検査せず `div` 効果が付く
- `list` の `map` / `filter` / `foldl` / `find`、`Cons` / `Nil` のパターン
- `maybe` と `.show`
- 自分の型に `(==)` / `show` を定義する (関数名はドット記法で使える)
- struct のコピー更新 `i(qty = 0)`

## 実行

```sh
koka -e data.kk
```

## 期待される出力

```
(1 + 2) * 4 = 12
total: 700
in stock: apple, bread
find bread: qty=2
find milk: Nothing
first: Just("apple")
Food: 700
Tool: 0
sold out apple qty: 0
```
