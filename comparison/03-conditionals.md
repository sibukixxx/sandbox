# 03. 条件分岐を関数として書く、を 10 言語で

## 結論 (一覧表)

| 言語 | `if` は式か | `match` / パターン | ガード | タプルで複数条件 | Option 相当 | 分岐の性質を検証できるか |
|---|---|---|---|---|---|---|
| MoonBit | ✅ 式 | `match` (腕にカンマ不要) | `n if n < 0` | ✅ | `Int?` (組込み) | テスト (`test { }`) |
| OxCaml | ✅ 式 | `match` / `function` | `when` | ✅ (括弧なし) | `option` + `let*` | テスト。`[@zero_alloc]` で割り当てを検査 |
| Lean 4 | ✅ 式 | `match a, b with` / 引数直接 | なし (if で代用) | ✅ (カンマ区切り) | `Option` + `do` | **証明** (`decide`, `theorem`) |
| Quint | ✅ 式 (括弧必須) | `match` (腕に `\|` 必須) | なし | ❌ (`and` で組む) | 自作の和型 | **テスト + シミュレーション** |
| Verse | ✅ 式 | `case` | なし | ❌ (`and` で組む) | `?int` / `<decides>` 関数 | — (UEFN 未確認) |
| Dafny | ✅ 式 (function 内) / 文 (method 内) | `match ... case` | なし | ✅ | 自作 `datatype Option` | **自動証明** (`ensures`, `lemma`) |
| Rust no_std | ✅ 式 | `match` | `n if n < 0` | ✅ | `Option` + `?` | テスト。`const fn` でコンパイル時評価 |
| Zig | ✅ 式 | `switch` (範囲 `1...9`) | なし (else に if) | ❌ (bool で組む) | `?T` + `orelse`、`E!T` + `try` | テスト。定数引数はコンパイル時評価 |
| Gleam | ✅ (`if` なし、`case` のみ) | `case` + ガード | `_ if x > 0` | ✅ (`case a, b`) | `Option` / `Result` + `use` | テスト (gleeunit) |
| Koka | ✅ 式 | `match` + ガード | `n \| n < 0` | ✅ | `maybe` / `exn` 効果 | 効果型で「失敗しうる」が型に出る |

## 言語ごとのコード

題材は共通で `sign(x)` (正 / 負 / 0) と `fizzbuzz(n)`。

### MoonBit → [examples](../moonbit/examples/02-basics/)

```moonbit
pub fn sign(x : Int) -> String {
  if x > 0 { "positive" } else if x < 0 { "negative" } else { "zero" }
}

pub fn fizzbuzz(n : Int) -> String {
  match (n % 3, n % 5) {
    (0, 0) => "FizzBuzz"
    (0, _) => "Fizz"
    (_, 0) => "Buzz"
    _ => n.to_string()
  }
}
```

Rust 風だが `match` の腕にカンマがない。`?` 演算子は Option には使えない (エラー伝播専用)。

### OxCaml → [examples](../oxcaml/examples/02-basics/)

```ocaml
let sign x =
  if x > 0 then "positive" else if x < 0 then "negative" else "zero"

let fizzbuzz n =
  match n mod 3, n mod 5 with
  | 0, 0 -> "FizzBuzz"
  | 0, _ -> "Fizz"
  | _, 0 -> "Buzz"
  | _ -> string_of_int n
```

型注釈なしで推論される。OxCaml では `[@zero_alloc]` を付けて「分岐でヒープ割り当てが起きない」ことを検査できる。

### Lean 4 → [examples](../lean/examples/02-basics/)

```lean
def sign (x : Int) : String :=
  if x > 0 then "positive" else if x < 0 then "negative" else "zero"

def fizzbuzz (n : Nat) : String :=
  match n % 3, n % 5 with
  | 0, 0 => "FizzBuzz"
  | 0, _ => "Fizz"
  | _, 0 => "Buzz"
  | _, _ => toString n

theorem sign_nonempty (x : Int) : sign x ≠ "" := by
  unfold sign; split; · simp; · split <;> simp
```

分岐について **定理を証明** できる。依存 if (`if h : i < xs.size then xs[i]`) で条件の証明を分岐内で使える。

### Quint → [examples](../quint/examples/02-basics/)

```quint
pure def sign(x: int): str =
  if (x > 0) "positive" else if (x < 0) "negative" else "zero"

pure def fizzbuzz(n: int): str =
  if (n % 3 == 0 and n % 5 == 0) "FizzBuzz"
  else if (n % 3 == 0) "Fizz"
  else if (n % 5 == 0) "Buzz"
  else "number"
```

タプルの match はなく `and` で組む。int → str 変換もない (仕様記述では不要)。

### Verse → [examples](../verse/examples/02-basics/) (UEFN 未確認)

```verse
Sign(X:int):string =
    if (X > 0) then "positive"
    else if (X < 0) then "negative"
    else "zero"

IsPositive(X:int)<decides><transacts>:void =
    X > 0

if (IsPositive[5]):
    Print("positive")
```

条件が bool ではなく **失敗しうる式**。`<decides>` 関数を `F[x]` で呼ぶと、成功 / 失敗が分岐になる。

### Dafny → [examples](../dafny/examples/02-basics/)

```dafny
function Sign(x: int): string
{
  if x > 0 then "positive" else if x < 0 then "negative" else "zero"
}

function Abs(x: int): int
  ensures Abs(x) >= 0
{
  if x < 0 then -x else x
}

lemma SignNonEmpty(x: int)
  ensures Sign(x) != ""
{ }
```

`function` は式、`method` は文。`ensures` を書くと Z3 が **自動で証明** する。`lemma` の本体は空でよい。

### Rust (no_std) → [examples](../rust-no-std/examples/02-basics/)

```rust
pub fn sign(x: i32) -> &'static str {
    if x > 0 { "positive" } else if x < 0 { "negative" } else { "zero" }
}

pub const fn abs(x: i32) -> i32 {
    if x < 0 { -x } else { x }
}

pub fn fizzbuzz(n: u32) -> &'static str {
    match (n % 3, n % 5) {
        (0, 0) => "FizzBuzz", (0, _) => "Fizz", (_, 0) => "Buzz", _ => "number",
    }
}
```

`core` だけで `if` / `match` / `Option` / `?` が全部使える。`const fn` でコンパイル時評価。`String` はないので `&'static str` を返す。

### Zig → [examples](../zig/examples/02-basics/)

```zig
fn classify(x: i32) []const u8 {
    return switch (x) {
        0 => "zero",
        1...9 => "small",
        else => if (x < 0) "negative" else "large",
    };
}

const DivError = error{DivisionByZero};
fn safeDiv(a: i32, b: i32) DivError!i32 {
    if (b == 0) return error.DivisionByZero;
    return @divTrunc(a, b);
}
```

`switch` は範囲パターンと網羅性検査を持つ。「値なし」は `?T`、「失敗理由」は `E!T` と、2 つを型で区別する。

### Gleam → [examples](../gleam/examples/02-basics/)

```gleam
pub fn fizzbuzz(n: Int) -> String {
  case n % 3, n % 5 {
    0, 0 -> "FizzBuzz"
    0, _ -> "Fizz"
    _, 0 -> "Buzz"
    _, _ -> int.to_string(n)
  }
}

pub fn average_of_two(a: Int, b: Int, divisor: Int) -> Result(Int, String) {
  use x <- result.try(safe_div(a, divisor))
  use y <- result.try(safe_div(b, divisor))
  Ok({ x + y } / 2)
}
```

`if` がなく、すべて `case`。`use` 構文が `?` / `do` 記法の役割を果たす。

### Koka → [examples](../koka/examples/02-basics/)

```koka
fun sign-of(x : int) : string
  if x > 0 then "positive"
  elif x < 0 then "negative"
  else "zero"

fun safe-div(a : int, b : int) : exn int
  if b == 0 then throw("division by zero") else a / b
```

`throw` する関数の型に `exn` 効果が付く。「失敗しうる」がシグネチャで分かり、`try` でハンドルすると消える。

## 違いはどこから来るか

1. **「式か文か」は決着済み**。10 言語すべてで `if` / `case` は式。Dafny だけが `method` 内では文になる (手続きと純粋関数を分けるため)。Gleam は `if` 自体を持たず `case` に統一した。
2. **「条件とは何か」が分かれる**。6 言語は bool、Verse だけは「失敗しうる式」。この違いが `<decides>` や `for` の絞り込みなど Verse 全体の設計につながる。
3. **「分岐の正しさをどう保証するか」が 3 段階ある**。テストで確認 (MoonBit, OxCaml, Rust, Quint) → 自動証明 (Dafny) → 自分で証明 (Lean)。右に行くほど強いが重い。
4. **Option を組込みで持つか**。Rust / MoonBit / Lean / OCaml / Zig / Gleam / Koka は組込み、Quint / Dafny は和型で自作、Verse は `?int` と `<decides>` の 2 通り。
5. **「失敗」を型のどこに書くか**。Rust / Zig / Gleam は戻り値の型 (`Result`, `E!T`)、Koka は効果 (`exn`)、Verse は `<decides>`。Koka の効果は関数の「戻り値」ではなく「振る舞い」の記述で、ハンドラで消せる点が違う。

## どれを選ぶか

| こういう人 | この言語 |
|---|---|
| `match` の網羅性検査を最大限使いたい | Rust, MoonBit, OCaml, Lean |
| 分岐の正しさを機械に証明させたい (楽に) | Dafny |
| 分岐の正しさを自分で証明したい (深く) | Lean 4 |
| 「条件 = 失敗しうる式」という別の考え方を体験したい | Verse |
| 「値なし」と「失敗理由」を型で使い分けたい | Zig, Gleam |
| 失敗を効果として型に出したい | Koka |
