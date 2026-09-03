# 04. データ構造

対応サンプル: [`examples/03-data/`](../examples/03-data/)

## 目的

OCaml のバリアント・レコード・List・Map (ファンクタ) を使い、OxCaml の unboxed 型がレコードに何をもたらすかを知る。

## 最小コード

```ocaml
type category = Food | Tool
type item = { name : string; price : int; qty : int; category : category }
type expr = Num of int | Add of expr * expr | Mul of expr * expr

let rec eval = function
  | Num n -> n
  | Add (a, b) -> eval a + eval b
  | Mul (a, b) -> eval a * eval b

let total_value items =
  items |> List.map (fun i -> i.price * i.qty) |> List.fold_left ( + ) 0

module CatMap = Map.Make (struct type t = category let compare = compare end)
```

## 解説

### 型の一覧

| 型 | 書き方 | 主な操作 |
|---|---|---|
| バリアント | `Num of int \| Add of expr * expr` | `match` / `function` |
| レコード | `{ name : string; qty : int }` | `r.name`, `{ r with qty = 0 }` |
| タプル | `(1, "a")` | `let a, b = t` |
| `list` | `[1; 2]` | `List.map`, `filter`, `fold_left`, `find_opt`, `x :: xs` |
| `array` | `[\|1; 2\|]` | 可変・固定長、`a.(i)`, `Array.sort` |
| `option` | `Some v` / `None` | `Option.map`, `Option.bind`, `let*` |
| `Map` / `Set` | `Map.Make(Ord)` | ファンクタで型ごとに生成。`add`, `find_opt`, `update`, `iter` |

### Map はファンクタで作る

```ocaml
module CatMap = Map.Make (struct
  type t = category
  let compare = compare
end)
```

キーの比較方法をモジュールとして渡す。生成された `CatMap.t` は不変で、`add` / `update` は新しい Map を返す。

### 再帰型

GC があるので `Add of expr * expr` と直接書ける。`let rec` + `function` で再帰的パターンマッチ。

### OxCaml 固有: unboxed 型

```ocaml
type point = { x : float#; y : float# }
let min_max a b : #(int * int) = if a < b then #(a, b) else #(b, a)
```

- 標準 OCaml では `float` フィールドはボックス化される (レコード + float ごとの割り当て)。`float#` は unboxed で、1 レコード = 1 割り当て。
- `#(int * int)` は unboxed タプル。複数の値を返してもヒープ割り当てが起きない。
- これらは **layout** という概念に基づく (`value` / `float64` / `bits64` など)。ジェネリックな関数には `value` しか渡せないので、unboxed 値を扱う関数は型注釈が要る。

## 他の言語ではこう書く

Rust の `struct` は既定で unboxed、OCaml は既定で boxed。OxCaml はその中間を選べるようにした。
Rust の `HashMap<K, V>` はジェネリック、OCaml の `Map.Make` はファンクタ適用で型ごとにモジュールを作る。

## 落とし穴

- レコードのフィールド名はモジュール内で一意。同じ名前のフィールドを持つ 2 つのレコード型があると型推論が混乱する (型注釈で解決)。
- `List.hd` は空リストで例外。`match` か `List.nth_opt` を使う。
- `compare` は多相比較で、関数を含む値には使えない。
