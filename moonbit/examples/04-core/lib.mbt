///|
/// ブラウザ / Node から呼ぶ関数。`pub` かつ `#export_name` でシンボル名を付ける。
#export_name("fib")
pub fn fib(n : Int) -> Int {
  if n < 2 {
    n
  } else {
    fib(n - 1) + fib(n - 2)
  }
}

///|
#export_name("sum_to")
pub fn sum_to(n : Int) -> Int {
  let mut acc = 0
  for i in 1..=n {
    acc += i
  }
  acc
}

///|
/// テストはソースに直接書く。`moon test` は全ターゲットで同じテストを実行できる:
///   moon test --target wasm-gc / js / native
test "fib" {
  assert_eq(fib(0), 0)
  assert_eq(fib(1), 1)
  assert_eq(fib(10), 55)
}

///|
/// スナップショットテスト: `content` を空にして `moon test --update` すると値が書き込まれる。
/// 期待値を手で書かなくてよいので、複雑な出力のテストに向く。
test "snapshot" {
  let xs = []
  for i in 0..<8 {
    xs.push(fib(i))
  }
  inspect(xs, content="[0, 1, 1, 2, 3, 5, 8, 13]")
}

///|
/// 失敗しうる関数のテスト: `!` は raise を伝播する
fn parse_positive(s : String) -> Int raise {
  let n = @strconv.parse_int(s)
  if n <= 0 {
    fail("not positive: \{s}")
  }
  n
}

///|
test "raise" {
  assert_eq(parse_positive("12"), 12)
  // 失敗することのテスト: try ... catch でエラーを受け取り、noraise (成功した場合) は fail
  try parse_positive("-1") catch {
    e => assert_true(e is Failure(_))   // エラーの種類だけ検査 (メッセージには行番号が入るため)
  } noraise {
    _ => fail("expected parse_positive to raise")
  }
}
