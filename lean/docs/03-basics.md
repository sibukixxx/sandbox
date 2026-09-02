# 03. 条件分岐を関数として書く

対応サンプル: [`examples/02-basics/`](../examples/02-basics/)

## 目的

`if` / `match` が式であることに加え、Lean 固有の「引数の直接パターンマッチ」「依存 if」「分岐の性質の証明」を体験する。

## 最小コード

```lean
def sign (x : Int) : String :=
  if x > 0 then "positive"
  else if x < 0 then "negative"
  else "zero"

def fizzbuzz (n : Nat) : String :=
  match n % 3, n % 5 with
  | 0, 0 => "FizzBuzz"
  | 0, _ => "Fizz"
  | _, 0 => "Buzz"
  | _, _ => toString n

def describe : Nat → String
  | 0     => "zero"
  | 1     => "one"
  | n + 1 => s!"successor of {n}"
```

## 解説

- **`if ... then ... else`** は式。`else` は省略できない (値を返す必要があるため)。
- **`match a, b with`** で複数の値を同時に照合できる。タプルにしなくてよい。
- **引数の直接パターンマッチ**: `def f : Nat → String | 0 => ... | n + 1 => ...` の形。`n + 1` は「1 以上」を表すパターンで、Lean は再帰が停止することを自動確認する。
- **`Option` と `do`**: `do` ブロック内の `let x ← opt` は、`none` なら全体が `none` になる (早期 return)。
- **依存 if**: `if h : i < xs.size then xs[i] else 0` と書くと、then 側で `h` (条件が成り立つ証明) が使える。`xs[i]` は境界チェック不要の安全なアクセスになる。

### 分岐の性質を証明する

```lean
example : fizzbuzz 15 = "FizzBuzz" := by decide

theorem sign_nonempty (x : Int) : sign x ≠ "" := by
  unfold sign
  split
  · simp
  · split <;> simp
```

- `decide` は具体値を計算して確認する。テストに相当する。
- `theorem` は全ての `x` について証明する。`split` で `if` を場合分けし、各場合を `simp` で閉じる。

## 他の言語ではこう書く

Haskell の関数定義 `f 0 = ...; f (n+1) = ...` とほぼ同じ。
Lean ではさらに「その関数についての定理」を同じファイルに書け、コンパイル時に検証される。

## 落とし穴

- `if x = 0` の `=` は命題の等号。`==` は `Bool` を返す演算子で、両方使えるが証明では `=` を使う。
- `Int` の `/` は整数除算 (0 除算は 0 を返す)。`Nat` の引き算は 0 で止まる (`3 - 5 = 0`)。
- `split <;> simp` で閉じない場合は、ネストした `if` を順に `split` する。
