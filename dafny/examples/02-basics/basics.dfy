// 条件分岐を「関数」として書く。
// Dafny には 2 種類の「関数」がある:
//   function : 純粋。式で書く。仕様 (requires/ensures) の中でも使える
//   method   : 手続き。文で書く。副作用を持てる。仕様の中では使えない

// function の本体は 1 つの式。if-then-else は式。
function Sign(x: int): string
{
  if x > 0 then "positive"
  else if x < 0 then "negative"
  else "zero"
}

// 複数条件は && / || で組み合わせる。
function FizzBuzz(n: nat): string
{
  if n % 3 == 0 && n % 5 == 0 then "FizzBuzz"
  else if n % 3 == 0 then "Fizz"
  else if n % 5 == 0 then "Buzz"
  else "number"
}

// 代数的データ型と match 式
datatype Shape = Circle(r: int) | Square(a: int) | Point

function Area(s: Shape): int
{
  match s
  case Circle(r) => 3 * r * r
  case Square(a) => a * a
  case Point => 0
}

// Option 相当は datatype で定義する (標準ライブラリにもある)
datatype Option<T> = Some(value: T) | None

function CheckedDiv(a: int, b: int): Option<int>
{
  if b == 0 then None else Some(a / b)
}

function AverageOfTwo(a: int, b: int, divisor: int): Option<int>
{
  match (CheckedDiv(a, divisor), CheckedDiv(b, divisor))
  case (Some(x), Some(y)) => Some((x + y) / 2)
  case _ => None
}

// --- Dafny らしい部分: 条件分岐の性質を仕様として書き、検証器に証明させる ---

// ensures: この関数が返す値について常に成り立つこと。検証器が自動で確認する。
function Abs(x: int): int
  ensures Abs(x) >= 0
  ensures Abs(x) == x || Abs(x) == -x
{
  if x < 0 then -x else x
}

// method 版。文で書くので if 文になり、戻り値は名前付き (r)。
method Max(a: int, b: int) returns (r: int)
  ensures r >= a && r >= b
  ensures r == a || r == b
{
  if a > b {
    r := a;
  } else {
    r := b;
  }
}

// requires: 呼び出し側が守るべき前提条件。守らない呼び出しはコンパイルエラーになる。
method SafeDiv(a: int, b: int) returns (q: int)
  requires b != 0
  ensures q == a / b
{
  q := a / b;
}

// lemma: 実行されないが、性質を証明する。ここでは Sign が空文字を返さないこと。
lemma SignNonEmpty(x: int)
  ensures Sign(x) != ""
{
  // 検証器が自動で 3 つの分岐を場合分けして証明する。本体は空でよい。
}

method Main() {
  var i := 1;
  while i <= 15
    invariant 1 <= i <= 16   // ループ不変条件。while には必ず必要
  {
    print i, ": ", FizzBuzz(i), " / ", Sign(i - 8), "\n";
    i := i + 1;
  }
  print Area(Circle(2)), " ", Area(Point), "\n";
  print AverageOfTwo(6, 4, 2), " ", AverageOfTwo(6, 4, 0), "\n";
  var m := Max(3, 7);
  var q := SafeDiv(10, 2);   // SafeDiv(10, 0) は検証エラーになる
  print m, " ", q, " ", Abs(-5), "\n";
}
