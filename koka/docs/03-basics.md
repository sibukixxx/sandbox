# 03. 条件分岐を関数として書く

対応サンプル: [`examples/02-basics/`](../examples/02-basics/)

## 目的

式指向の `if` / `match` と、`maybe` と `exn` 効果による「値なし」「失敗」の 2 通りの表し方を学ぶ。

## 最小コード

```koka
fun sign-of(x : int) : string
  if x > 0 then "positive"
  elif x < 0 then "negative"
  else "zero"

fun fizzbuzz(n : int) : string
  match (n % 3, n % 5)
    (0, 0) -> "FizzBuzz"
    (0, _) -> "Fizz"
    (_, 0) -> "Buzz"
    _ -> n.show

fun safe-div(a : int, b : int) : exn int
  if b == 0 then throw("division by zero") else a / b
```

## 解説

- **`if ... then ... elif ... else`** は式。ブロック形式では最後の式が値。
- **`match`** の腕は `パターン -> 式`。ガードは `n | n < 0 -> ...`。タプルの match で複数条件をまとめる。
- **`maybe<a>`**: `Just(v)` / `Nothing`。他言語の Option。
- **`exn` 効果**: `throw` する関数の型に `exn` が付く。`try(action) fn(err) ...` でハンドルすると `exn` が消える。「失敗理由」を持つ点で `maybe` と使い分ける。
- **`total`**: 何の効果もない純粋関数。`: total int` と書けるが省略可。
- **ドット記法**: `n.show` は `show(n)`。第 1 引数に対して任意の関数を後置できる。
- **識別子にハイフン**: `sign-of` のように書ける (`a - b` は空白が要る)。

## 他の言語ではこう書く

OCaml の `match` とほぼ同じ。例外を型で追跡する点が違う: OCaml では `raise` する関数の型に何も現れないが、Koka では `exn` が現れる。

## 落とし穴

- `abs`, `sign` など標準にある名前と衝突する。エラーメッセージの `candidates` を見て別名にする。
- `assert` は `assert("message", cond)` の順。
- テストフレームワークは標準にない。`main` で `assert` するか、`koka` の `:t` で型を確認する。
