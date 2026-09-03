# 03 データ構造とパターンマッチ

## 学ぶこと

- レコード `{ name: str, ... }`、和型 `Food | Tool`、コンストラクタの引数はレコードにまとめる
- **再帰的なデータ型は定義できない** (有限状態を扱う言語なので意図的)
- `List` の `foldl` / `select` / `head` / `length`
- Option がないので「見つかった要素の `Set`」で表す定石
- `Map` は不変。`setBy` / `put` で新しい Map を返す。`Category -> int` が Map の型

## 実行

```sh
quint typecheck data.qnt
quint test data.qnt
```

## 期待される出力

```
    ok exprTest passed 1 test(s)
    ok listTest passed 1 test(s)
    ok mapTest passed 1 test(s)
```
