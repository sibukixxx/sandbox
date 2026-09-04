# 03. 条件分岐を関数として書く

対応サンプル: [`examples/02-basics/`](../examples/02-basics/)

## 目的

`if` のない言語で条件分岐を `case` 式として書き、`Result` と `use` で失敗を扱う。

## 最小コード

```gleam
pub fn sign(x: Int) -> String {
  case x {
    _ if x > 0 -> "positive"
    _ if x < 0 -> "negative"
    _ -> "zero"
  }
}

pub fn fizzbuzz(n: Int) -> String {
  case n % 3, n % 5 {
    0, 0 -> "FizzBuzz"
    0, _ -> "Fizz"
    _, 0 -> "Buzz"
    _, _ -> int.to_string(n)
  }
}

pub fn average_of_two(a: Int, b: Int, divisor: Int) -> Result(Int, String) {
  use x <- result.try(safe_div(a, divisor))
  use y <- result.try(safe_div(b, divisor))
  Ok({ x + y } / 2)
}
```

## 解説

- **`if` がない**。`case` 式にガード (`_ if x > 0`) を書く。Bool を `case` してもよい。
- **複数の値の照合**: `case a, b { 0, 0 -> ... }`。タプルにしなくてよい。
- **範囲パターンはない**。ガードで `n if n < 10`。
- **`Option` と `Result`**: `Option` は値の有無、`Result(value, error)` は失敗理由付き。Gleam の標準は `Result` で、標準ライブラリの失敗しうる関数はほぼ `Result` を返す。
- **`use` 構文**: `use x <- result.try(r)` は「`r` が `Ok(x)` なら続きを実行、`Error` ならそれを返す」。他言語の `?` や `do` 記法に相当し、コールバックのネストを平らにする汎用構文。
- **式のブロック**: `{ x + y } / 2` の `{ }` は式のグループ化 (括弧の代わり)。
- **テスト**: `test/*_test.gleam` に `pub fn xxx_test()` を書き、`gleeunit` が実行する。

## 他の言語ではこう書く

Rust の `match` + `?` に相当するのが `case` + `use ... result.try`。Elixir の `with` 構文と同じ目的だが、Gleam の `use` は任意の高階関数に使える。

## 落とし穴

- `list.range` は廃止された。`int.range(from, to, acc, fn)` か `list.repeat` を使う。
- パイプ `|>` は「最初の引数に渡す」。`x |> f(y)` は `f(x, y)`。
- 標準ライブラリの関数はラベル付き引数を持つことが多い (`process.call(subject, waiting: 100, sending: Get)`)。
