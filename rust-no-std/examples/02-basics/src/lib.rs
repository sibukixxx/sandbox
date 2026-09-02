//! 条件分岐を「関数」として書く。
//! `if` / `match` は式なので、値を返す関数の本体にそのまま置ける。
//! すべて `core` だけで動く (std 不要)。

// テスト時だけ std を有効にする。テストハーネス自体が std を必要とするため。
#![cfg_attr(not(test), no_std)]

/// if-else 式。各分岐が同じ型 (&'static str) を返す。
pub fn sign(x: i32) -> &'static str {
    if x > 0 {
        "positive"
    } else if x < 0 {
        "negative"
    } else {
        "zero"
    }
}

/// match + ガード (`if`) 。上から順に最初に一致した腕が選ばれる。
pub fn classify(x: i32) -> &'static str {
    match x {
        0 => "zero",
        n if n < 0 => "negative",
        1..=9 => "small",
        _ => "large",
    }
}

/// 複数条件をタプルにまとめて match する。網羅性はコンパイラが検査する。
pub fn fizzbuzz(n: u32) -> &'static str {
    match (n % 3, n % 5) {
        (0, 0) => "FizzBuzz",
        (0, _) => "Fizz",
        (_, 0) => "Buzz",
        _ => "number",
    }
}

/// `const fn` にすると、コンパイル時にも評価できる。
/// no_std では静的テーブルをコンパイル時に作る用途で重宝する。
pub const fn abs(x: i32) -> i32 {
    if x < 0 {
        -x
    } else {
        x
    }
}

/// Option を返す関数。「値がない」も分岐の 1 つとして型で表す。
pub fn checked_div(a: i32, b: i32) -> Option<i32> {
    if b == 0 {
        None
    } else {
        Some(a / b)
    }
}

/// Option の分岐は match でも、`?` 演算子でも書ける。
pub fn average_of_two(a: i32, b: i32, divisor: i32) -> Option<i32> {
    let sum = checked_div(a, divisor)? + checked_div(b, divisor)?;
    Some(sum / 2)
}

// コンパイル時評価の例: const fn なので static の初期化に使える
pub static ABS_MIN: i32 = abs(-7);

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn sign_works() {
        assert_eq!(sign(3), "positive");
        assert_eq!(sign(-3), "negative");
        assert_eq!(sign(0), "zero");
    }

    #[test]
    fn classify_works() {
        assert_eq!(classify(0), "zero");
        assert_eq!(classify(-1), "negative");
        assert_eq!(classify(5), "small");
        assert_eq!(classify(50), "large");
    }

    #[test]
    fn fizzbuzz_works() {
        assert_eq!(fizzbuzz(15), "FizzBuzz");
        assert_eq!(fizzbuzz(9), "Fizz");
        assert_eq!(fizzbuzz(10), "Buzz");
        assert_eq!(fizzbuzz(7), "number");
    }

    #[test]
    fn const_and_option() {
        assert_eq!(ABS_MIN, 7);
        assert_eq!(checked_div(6, 0), None);
        assert_eq!(average_of_two(6, 4, 2), Some(2));
        assert_eq!(average_of_two(6, 4, 0), None);
    }
}
