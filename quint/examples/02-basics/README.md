# 02 条件分岐を関数として書く

## 学ぶこと

- `if (cond) a else b` は **式**。`else` は省略できない
- `and` / `or` で複数条件を組み合わせる (タプルの match はない)
- 和型 `type Shape = Circle(int) | Square(int) | Point` と `match` 式
- Option 相当は和型で自分で定義する
- 集合に対する `forall` / `exists`
- `run xxxTest = all { assert(...), ... }` と `quint test`

## 実行

```sh
quint typecheck basics.qnt
quint test basics.qnt
```

## 期待される出力

```
  basics
    ok signTest passed 1 test(s)
    ok fizzbuzzTest passed 1 test(s)
    ok matchTest passed 1 test(s)

  3 passing (...)
```
