# 03. 条件分岐を関数として書く

対応サンプル: [`examples/02-basics/`](../examples/02-basics/)

## 目的

`if` / `match` が式であることを利用して、条件分岐を「値を返す関数」として書き、`test` ブロックで検証する。

## 最小コード

```moonbit
pub fn sign(x : Int) -> String {
  if x > 0 {
    "positive"
  } else if x < 0 {
    "negative"
  } else {
    "zero"
  }
}

pub fn classify(x : Int) -> String {
  match x {
    0 => "zero"
    n if n < 0 => "negative"
    1..=9 => "small"
    _ => "large"
  }
}

pub fn fizzbuzz(n : Int) -> String {
  match (n % 3, n % 5) {
    (0, 0) => "FizzBuzz"
    (0, _) => "Fizz"
    (_, 0) => "Buzz"
    _ => n.to_string()
  }
}

test "sign" {
  assert_eq(sign(3), "positive")
}
```

## 解説

- **式としての `if` / `match`**: 最後の式が戻り値。`return` は不要。分岐の型が揃わないとコンパイルエラー。
- **`match` の腕**: `=>` の後に式。腕の区切りは改行で、カンマは不要。ガード `n if n < 0`、範囲 `1..=9`、タプル `(a, b)` が使える。
- **`Int?`**: `Option[Int]` の省略記法。`Some(v)` / `None`。「値がない」も分岐として型で表す。
- **`test "name" { }`**: ソースファイル内に直接テストを書く。`moon test` で実行。`assert_eq` は標準。
- **`?` 演算子は Option には使えない**。MoonBit の `?` はエラー (`raise`) 伝播用。Option の合成はタプルにして `match` するか、`.bind` / `.map` を使う。

## 他の言語ではこう書く

Rust とほぼ同じ書き味だが、`match` の腕にカンマがない、`Int?` という Option 省略記法がある、テストがソース内に書ける、の 3 点が違う。

## 落とし穴

- 関数の引数の型注釈は必須 (`x : Int`)。戻り値の型も `-> String` と書く。
- `let sum = f()? + g()?` のように Option に `?` を使うと構文エラーになる。
