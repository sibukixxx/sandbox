///|
/// if-else は式。各分岐が同じ型 (String) を返す。
pub fn sign(x : Int) -> String {
  if x > 0 {
    "positive"
  } else if x < 0 {
    "negative"
  } else {
    "zero"
  }
}

///|
/// match 式 + ガード (`if`)。上から順に最初に一致した腕が選ばれる。
pub fn classify(x : Int) -> String {
  match x {
    0 => "zero"
    n if n < 0 => "negative"
    1..=9 => "small"
    _ => "large"
  }
}

///|
/// 複数条件をタプルにまとめて match する。網羅性はコンパイラが検査する。
pub fn fizzbuzz(n : Int) -> String {
  match (n % 3, n % 5) {
    (0, 0) => "FizzBuzz"
    (0, _) => "Fizz"
    (_, 0) => "Buzz"
    _ => n.to_string()
  }
}

///|
/// Option を返す関数。「値がない」も分岐の 1 つとして型で表す。
pub fn checked_div(a : Int, b : Int) -> Int? {
  if b == 0 {
    None
  } else {
    Some(a / b)
  }
}

///|
/// 2 つの Option をタプルにして match する。どちらかが None なら None。
/// (MoonBit の `?` 演算子はエラー (raise) 用で、Option には使えない)
pub fn average_of_two(a : Int, b : Int, divisor : Int) -> Int? {
  match (checked_div(a, divisor), checked_div(b, divisor)) {
    (Some(x), Some(y)) => Some((x + y) / 2)
    _ => None
  }
}

///|
/// テストはソースと同じファイルに `test` ブロックで書ける。
test "sign" {
  assert_eq(sign(3), "positive")
  assert_eq(sign(-3), "negative")
  assert_eq(sign(0), "zero")
}

///|
test "classify" {
  assert_eq(classify(0), "zero")
  assert_eq(classify(-1), "negative")
  assert_eq(classify(5), "small")
  assert_eq(classify(50), "large")
}

///|
test "fizzbuzz" {
  assert_eq(fizzbuzz(15), "FizzBuzz")
  assert_eq(fizzbuzz(9), "Fizz")
  assert_eq(fizzbuzz(10), "Buzz")
  assert_eq(fizzbuzz(7), "7")
}

///|
test "option" {
  assert_eq(checked_div(6, 0), None)
  assert_eq(average_of_two(6, 4, 2), Some(2))
  assert_eq(average_of_two(6, 4, 0), None)
}
