# 03 データ構造とパターンマッチ

## 学ぶこと

- カスタム型 (列挙、レコード、再帰型) と `case` によるパターンマッチ
- `list.map` / `filter` / `fold` / `find` と `|>` パイプ
- リストパターン `[first, ..rest]`、`let assert` による分解
- `Option` と `Result`、`option.from_result`
- `Dict` と `dict.upsert`
- レコード更新構文 `Item(..i, qty: 0)`。すべて不変

## 実行

```sh
gleam run
gleam test
```

## 期待される出力

```
(1 + 2) * 4 = 12
total: 700
in stock: apple, bread
find bread: qty=2
find milk: none
first: apple
Food: 700
Tool: 0
sold out apple qty: 0
```
