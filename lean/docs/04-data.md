# 04. データ構造

対応サンプル: [`examples/03-data/`](../examples/03-data/)

## 目的

`inductive` / `structure` / `List` を使い、データ構造の性質を `decide` と `theorem` で確認する。

## 最小コード

```lean
inductive Category where
  | food
  | tool
  deriving Repr, DecidableEq, BEq

structure Item where
  name : String
  price : Nat
  qty : Nat
  category : Category
  deriving Repr, BEq

inductive Expr where
  | num : Int → Expr
  | add : Expr → Expr → Expr
  | mul : Expr → Expr → Expr

def Expr.eval : Expr → Int
  | .num n => n
  | .add a b => a.eval + b.eval
  | .mul a b => a.eval * b.eval

def totalValue (items : List Item) : Nat :=
  items.map (fun i => i.price * i.qty) |>.foldl (· + ·) 0
```

## 解説

### 型の定義

| 種類 | 書き方 | 備考 |
|---|---|---|
| 列挙 | `inductive C where \| a \| b` | |
| 再帰型 | `inductive Expr where \| add : Expr → Expr → Expr` | 停止性は構造的再帰なら自動 |
| レコード | `structure Item where name : String` | `{ name := "a", .. }` で生成、`i.name` で参照 |
| deriving | `Repr` (表示), `BEq` (`==`), `DecidableEq` (`=` の決定) | `decide` で使うには `DecidableEq` |

`.num n` のように型が分かる文脈では `Expr.num` を `.num` と省略できる。

### List

`List.map` / `filter` / `foldl` / `find?` (`?` 付きは Option を返す)。`|>.` はパイプで、`xs |>.map f` は `(xs).map f`。

パターンマッチは `[]` と `head :: tail`。`Array` (`#[1, 2]`) は添字アクセスが速く、`xs[i]` には `i < xs.size` の証明が要る (章 3 の依存 if)。

### Map

小さければ `List (K × V)` の連想リストで十分。本格的には `Std.HashMap` (`import Std`)。

### 性質の確認

```lean
example : totalValue sample = 700 := by decide
theorem totalValue_nil : totalValue [] = 0 := rfl
theorem totalValue_singleton (i : Item) : totalValue [i] = i.price * i.qty := by simp [totalValue]
```

- `decide`: 具体値を計算して確認 (テスト)。`DecidableEq` が要る
- `rfl`: 定義を展開すれば両辺が同じ
- `simp [f]`: `f` の定義を使って単純化

## 他の言語ではこう書く

Haskell の `data` / `record` とほぼ同じ。Lean では `deriving` が「その型の等値性が決定可能である」といった証明的な意味も持つ。

## 落とし穴

- `Nat` の引き算は 0 で止まる (`3 - 5 = 0`)。負になりうる計算は `Int`。
- `structure` に `Repr` を派生しないと `IO.println (repr x)` できない。
- `decide` は計算量が大きいと失敗する。大きな値は `native_decide` か `simp`。
