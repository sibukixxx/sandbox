// 条件分岐を「関数」として書く。Gleam には if がなく、すべて case 式。

import gleam/int
import gleam/io
import gleam/option.{type Option, None, Some}
import gleam/result

/// case 式 + ガード (`if`)。Bool の case でも書けるが、ガードの方が読みやすい
pub fn sign(x: Int) -> String {
  case x {
    _ if x > 0 -> "positive"
    _ if x < 0 -> "negative"
    _ -> "zero"
  }
}

/// case の腕は上から順。範囲パターンはないのでガードで書く
pub fn classify(x: Int) -> String {
  case x {
    0 -> "zero"
    n if n < 0 -> "negative"
    n if n < 10 -> "small"
    _ -> "large"
  }
}

/// 複数の値を同時に case する (タプルにしなくてよい)
pub fn fizzbuzz(n: Int) -> String {
  case n % 3, n % 5 {
    0, 0 -> "FizzBuzz"
    0, _ -> "Fizz"
    _, 0 -> "Buzz"
    _, _ -> int.to_string(n)
  }
}

/// Option: 「値がない」を型で表す
pub fn checked_div(a: Int, b: Int) -> Option(Int) {
  case b {
    0 -> None
    _ -> Some(a / b)
  }
}

/// Result: 「なぜ失敗したか」を持つ。Gleam の失敗の標準はこちら
pub fn safe_div(a: Int, b: Int) -> Result(Int, String) {
  case b {
    0 -> Error("division by zero")
    _ -> Ok(a / b)
  }
}

/// `use` 構文: Result を連鎖させる。`use x <- result.try(...)` で早期 return
pub fn average_of_two(a: Int, b: Int, divisor: Int) -> Result(Int, String) {
  use x <- result.try(safe_div(a, divisor))
  use y <- result.try(safe_div(b, divisor))
  Ok({ x + y } / 2)
}

pub fn main() -> Nil {
  // int.range(from, to, initial, fn(acc, n)) で 1..15 を畳み込む (list.range は廃止された)
  int.range(1, 15, Nil, fn(_, n) {
    io.println(int.to_string(n) <> ": " <> fizzbuzz(n) <> " / " <> classify(n))
  })
  io.println(string_of_result(average_of_two(6, 4, 2)))
  io.println(string_of_result(average_of_two(6, 4, 0)))
  case checked_div(6, 0) {
    None -> io.println("checked_div: none")
    Some(v) -> io.println("checked_div: " <> int.to_string(v))
  }
}

fn string_of_result(r: Result(Int, String)) -> String {
  case r {
    Ok(v) -> "Ok(" <> int.to_string(v) <> ")"
    Error(e) -> "Error(" <> e <> ")"
  }
}
