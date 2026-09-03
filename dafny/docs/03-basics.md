# 03. 条件分岐を関数として書く

対応サンプル: [`examples/02-basics/`](../examples/02-basics/)

## 目的

`function` (式) と `method` (文) の使い分けを知り、条件分岐の性質を `ensures` で検証器に証明させる。

## 最小コード

```dafny
function Sign(x: int): string
{
  if x > 0 then "positive"
  else if x < 0 then "negative"
  else "zero"
}

function Abs(x: int): int
  ensures Abs(x) >= 0
{
  if x < 0 then -x else x
}

method Max(a: int, b: int) returns (r: int)
  ensures r >= a && r >= b
{
  if a > b { r := a; } else { r := b; }
}
```

## 解説

### function と method

| | `function` | `method` |
|---|---|---|
| 本体 | 1 つの式 | 文の列 |
| 条件分岐 | `if c then a else b` (式) | `if c { } else { }` (文) |
| 戻り値 | 式の値 | `returns (r: int)` で名前を付け `r := ...` |
| 副作用 | なし | あり |
| 仕様の中で使えるか | 使える | 使えない |

「値を計算するだけ」なら `function`。`Sign` や `FizzBuzz` は function で書くのが自然。

### datatype と match

```dafny
datatype Shape = Circle(r: int) | Square(a: int) | Point

function Area(s: Shape): int
{
  match s
  case Circle(r) => 3 * r * r
  case Square(a) => a * a
  case Point => 0
}
```

`Option<T>` も `datatype Option<T> = Some(value: T) | None` と定義する。タプルの match `match (a, b) case (Some(x), Some(y)) => ...` も書ける。

### 仕様: requires / ensures / lemma

- `ensures Abs(x) >= 0`: 戻り値について常に成り立つこと。検証器が全ての `x` について自動で確認する。
- `requires b != 0`: 呼び出し側が守るべき条件。`SafeDiv(10, 0)` と書くと **実行前に** エラーになる。
- `lemma SignNonEmpty(x: int) ensures Sign(x) != ""`: 実行されない証明専用の method。本体が空でも、検証器が場合分けして証明できる。
- `while` には `invariant` が必須。書かないとループ後の状態について何も証明できない。

## 他の言語ではこう書く

`function` は OCaml / Lean の純粋関数、`method` は C# のメソッドに対応する。
Lean では `theorem` を tactic で自分が証明するが、Dafny は `ensures` を書けば Z3 が自動で証明する (証明できないときは `assert` や `lemma` で助ける)。

## 落とし穴

- `function` の中で `if` に `{ }` を使うと構文エラー。式なので `then` / `else`。
- `int` は無限精度。`nat` は 0 以上の `int` で、`n - 1` が `nat` にならないと検証エラーになる。
- `print` で datatype を出力すると `Option.Some(2)` のようにモジュール名付きで出る。
