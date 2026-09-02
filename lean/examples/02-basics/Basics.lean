/-! 条件分岐を「関数」として書く。
`if` / `match` は式なので、そのまま関数の本体になる。 -/

/-- if-then-else 式。各分岐が同じ型 (String) を返す。 -/
def sign (x : Int) : String :=
  if x > 0 then "positive"
  else if x < 0 then "negative"
  else "zero"

/-- match 式。整数リテラルと `_` (ワイルドカード) で分岐する。 -/
def classify (x : Int) : String :=
  match x with
  | 0 => "zero"
  | n => if n < 0 then "negative" else if n < 10 then "small" else "large"

/-- 複数条件をタプルにまとめて match する。 -/
def fizzbuzz (n : Nat) : String :=
  match n % 3, n % 5 with
  | 0, 0 => "FizzBuzz"
  | 0, _ => "Fizz"
  | _, 0 => "Buzz"
  | _, _ => toString n

/-- 引数を直接パターンマッチする書き方。`n+1` は「1 以上の自然数」。
    Lean はこの関数が必ず停止することを自動で確認する。 -/
def describe : Nat → String
  | 0     => "zero"
  | 1     => "one"
  | n + 1 => s!"successor of {n}"

/-- Option を返す関数。「値がない」も分岐の 1 つとして型で表す。 -/
def checkedDiv (a b : Int) : Option Int :=
  if b = 0 then none else some (a / b)

/-- `do` 記法の中では Option に対して `←` で早期 return できる。 -/
def averageOfTwo (a b divisor : Int) : Option Int := do
  let x ← checkedDiv a divisor
  let y ← checkedDiv b divisor
  pure ((x + y) / 2)

/-- 依存 if: `if h : cond then ... else ...` で、分岐の中で条件の証明 `h` が使える。
    ここでは「配列の添字が範囲内である証明」を渡して境界チェックなしでアクセスする。 -/
def safeGet (xs : Array Nat) (i : Nat) : Nat :=
  if h : i < xs.size then xs[i] else 0

-- 条件分岐の性質を「証明」できるのが Lean の特徴。
-- 具体値なら `decide` (計算して確認) で済む。
example : sign 3 = "positive" := by decide
example : fizzbuzz 15 = "FizzBuzz" := by decide
example : checkedDiv 6 0 = none := by decide

-- 全ての Int について成り立つ性質は、場合分けで証明する。
theorem sign_nonempty (x : Int) : sign x ≠ "" := by
  unfold sign
  split           -- 外側の if で場合分け
  · simp          -- x > 0 の場合
  · split <;> simp -- 内側の if で場合分けし、両方 simp で閉じる
