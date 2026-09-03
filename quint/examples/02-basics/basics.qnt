// 条件分岐を「関数」として書く。
// Quint の式はすべて値を返す。if-else も match も式。

module basics {
  // if-else 式。各分岐が同じ型 (str) を返す。else は省略できない
  pure def sign(x: int): str =
    if (x > 0) "positive"
    else if (x < 0) "negative"
    else "zero"

  // ネストした if を平らにするには、条件を先に val で名付けると読みやすい
  pure def classify(x: int): str = {
    val isSmall = x >= 1 and x <= 9
    if (x == 0) "zero"
    else if (x < 0) "negative"
    else if (isSmall) "small"
    else "large"
  }

  // 複数条件は and / or で組み合わせる (タプルの match はない)
  // (int → str の変換は標準にないので "number" を返す)
  pure def fizzbuzz(n: int): str =
    if (n % 3 == 0 and n % 5 == 0) "FizzBuzz"
    else if (n % 3 == 0) "Fizz"
    else if (n % 5 == 0) "Buzz"
    else "number"

  // 和型 (sum type) と match 式
  type Shape = Circle(int) | Square(int) | Point

  pure def area(s: Shape): int =
    match s {
      | Circle(r) => 3 * r * r
      | Square(a) => a * a
      | Point => 0
    }

  // Option 型は標準にはないので、和型で自分で定義するのが定石
  type Maybe = Some(int) | None

  pure def checkedDiv(a: int, b: int): Maybe =
    if (b == 0) None else Some(a / b)

  pure def averageOfTwo(a: int, b: int, divisor: int): Maybe =
    match checkedDiv(a, divisor) {
      | None => None
      | Some(x) => match checkedDiv(b, divisor) {
          | None => None
          | Some(y) => Some((x + y) / 2)
        }
    }

  // 集合に対する条件: 全称 / 存在
  pure def allPositive(xs: Set[int]): bool = xs.forall(x => x > 0)
  pure def hasEven(xs: Set[int]): bool = xs.exists(x => x % 2 == 0)

  // --- テスト。`quint test` で実行 ---
  run signTest = all {
    assert(sign(3) == "positive"),
    assert(sign(-3) == "negative"),
    assert(sign(0) == "zero"),
  }

  run fizzbuzzTest = all {
    assert(fizzbuzz(15) == "FizzBuzz"),
    assert(fizzbuzz(9) == "Fizz"),
    assert(fizzbuzz(10) == "Buzz"),
    assert(fizzbuzz(7) == "number"),
  }

  run matchTest = all {
    assert(area(Circle(2)) == 12),
    assert(area(Point) == 0),
    assert(checkedDiv(6, 0) == None),
    assert(averageOfTwo(6, 4, 2) == Some(2)),
    assert(averageOfTwo(6, 4, 0) == None),
    assert(allPositive(Set(1, 2, 3))),
    assert(not(hasEven(Set(1, 3)))),
  }
}
