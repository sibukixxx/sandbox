# 03. 条件分岐を関数として書く

対応サンプル: [`examples/02-basics/`](../examples/02-basics/)

## 目的

`if` / `match` が式であることを利用して、条件分岐を「値を返す関数」として書く。すべて `core` だけで動く。

## 最小コード

```rust
pub fn sign(x: i32) -> &'static str {
    if x > 0 { "positive" } else if x < 0 { "negative" } else { "zero" }
}

pub fn classify(x: i32) -> &'static str {
    match x {
        0 => "zero",
        n if n < 0 => "negative",
        1..=9 => "small",
        _ => "large",
    }
}

pub fn fizzbuzz(n: u32) -> &'static str {
    match (n % 3, n % 5) {
        (0, 0) => "FizzBuzz",
        (0, _) => "Fizz",
        (_, 0) => "Buzz",
        _ => "number",
    }
}
```

## 解説

- **式としての `if` / `match`**: 各分岐が同じ型を返せば、関数の最後の式としてそのまま戻り値になる。`return` は不要。
- **ガード** `n if n < 0`、**範囲パターン** `1..=9`、**タプル** `(n % 3, n % 5)` で複数条件を 1 つの `match` にまとめる。網羅性はコンパイラが検査する。
- **`const fn`**: `if` を含む関数も `const fn` にでき、`static` の初期化やルックアップテーブルの生成をコンパイル時に行える。`no_std` ではヒープが使えないことが多いので重要。
- **`Option` と `?`**: 「値がない」も分岐の 1 つ。`?` は `Option` に対しても使え、早期 return になる。`Option` / `Result` / `?` はすべて `core` にある。

## テストの書き方

`cargo test` はテストハーネスに `std` が必要。本体を `no_std` に保ったままテストするには次のようにする。

```rust
#![cfg_attr(not(test), no_std)]
```

## 他の言語ではこう書く

C では `if` は文なので、値を返すには三項演算子か `return` が必要。
Rust は `match` の網羅性検査があるため、分岐漏れをコンパイル時に検出できる点が異なる。

## 落とし穴

- `no_std` では `String` / `format!` が使えない。分岐の結果は `&'static str` や `enum` で返す。
- `f32::abs` などの一部の浮動小数点メソッドは `core` にない (libm 依存)。整数中心で書くか `libm` クレートを使う。
