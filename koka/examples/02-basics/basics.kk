// 条件分岐を「関数」として書く。Koka は式指向で、if / match は式。

// if-then-else 式。最後の式が戻り値 (sign は標準にあるので sign-of。識別子にハイフンが使える)
fun sign-of(x : int) : string
  if x > 0 then "positive"
  elif x < 0 then "negative"
  else "zero"

// match 式。ガード (`| n | n < 0`) と範囲はなく、条件はガードで書く
fun classify(x : int) : string
  match x
    0 -> "zero"
    n | n < 0 -> "negative"
    n | n < 10 -> "small"
    _ -> "large"

// タプルの match で複数条件をまとめる
fun fizzbuzz(n : int) : string
  match (n % 3, n % 5)
    (0, 0) -> "FizzBuzz"
    (0, _) -> "Fizz"
    (_, 0) -> "Buzz"
    _ -> n.show

// maybe 型 (Option 相当): Just / Nothing
fun checked-div(a : int, b : int) : maybe<int>
  if b == 0 then Nothing else Just(a / b)

// maybe の合成は match で。`with` 構文を使うとネストが平らになる (章 5)
fun average-of-two(a : int, b : int, divisor : int) : maybe<int>
  match (checked-div(a, divisor), checked-div(b, divisor))
    (Just(x), Just(y)) -> Just((x + y) / 2)
    _ -> Nothing

// 失敗しうる計算は exn 効果でも表せる。throw は exn 効果を持つ
fun safe-div(a : int, b : int) : exn int
  if b == 0 then throw("division by zero") else a / b

// 純粋な関数は total 効果 (何も起きない)。型に書くと `: total int` (省略可)。
// (abs は標準ライブラリにあるので名前を変えている)
fun absolute(x : int) : total int
  if x < 0 then 0 - x else x

fun main()
  for(1, 15) fn(n)
    println(n.show ++ ": " ++ fizzbuzz(n) ++ " / " ++ classify(n))
  println(average-of-two(6, 4, 2).show ++ " " ++ average-of-two(6, 4, 0).show)
  // exn 効果は try でハンドルする
  val q = try({ safe-div(1, 0) }) fn(err) { println("error: " ++ err.message); 0 }
  println("q = " ++ q.show)
  println(absolute(-7).show)
  // テスト代わりの assert
  assert("sign", sign-of(3) == "positive" && sign-of(-3) == "negative" && sign-of(0) == "zero")
  assert("fizzbuzz", fizzbuzz(15) == "FizzBuzz" && fizzbuzz(7) == "7")
  println("asserts ok")
