# 02 条件分岐を関数として書く

## 学ぶこと

- `function` (純粋・式) と `method` (手続き・文) の使い分け
- `if-then-else` 式、`&&` / `||`、`datatype` と `match`
- `Option<T>` を datatype で定義し、タプルの match で組み合わせる
- **`ensures` / `requires` / `lemma`** で分岐の性質を検証器に証明させる
- `while` には `invariant` が必要

## 実行

```sh
dafny run basics.dfy
```

## 期待される出力

```
Dafny program verifier finished with 9 verified, 0 errors
1: number / negative
2: number / negative
3: Fizz / negative
...
15: FizzBuzz / positive
12 0
Option.Some(2) Option.None
7 5 5
```

## 試してみる

`Main` の `SafeDiv(10, 2)` を `SafeDiv(10, 0)` に変えると、実行前に検証で止まる:

```
Error: a precondition for this call could not be proved
```
