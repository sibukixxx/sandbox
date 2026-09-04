# 04. データ構造、を 10 言語で

## 結論 (一覧表)

| 言語 | レコード | 列挙 / 和型 | 再帰型 | 標準の Option | List 操作 | Map | 不変 / 可変 |
|---|---|---|---|---|---|---|---|
| MoonBit | `struct` | `enum` (ペイロード可) | ✅ 直接 | `T?` | `map` / `filter` / `fold` | `Map[K, V]` (組込み、Hash 必須) | 可変 (Array, Map) |
| OxCaml | `type r = { .. }` | バリアント | ✅ 直接 | `option` | `List.map` / `fold_left` | `Map.Make` (ファンクタ) | 不変 (list, Map) / 可変 (array) |
| Lean 4 | `structure` | `inductive` | ✅ 直接 (停止性自動) | `Option` | `List.map` / `foldl` / `find?` | 連想リスト or `Std.HashMap` | 不変 |
| Quint | `{ a: int }` | 和型 (1 引数) | ❌ 意図的に無い | ❌ (Set で代用) | `foldl` / `select` | `K -> V` (組込み) | 不変 |
| Verse | `struct` (値型) | `enum` (ペイロード不可) | ❌ (クラス継承で代用) | `?T` | `for` 式 (map + filter) | `[K]V` (組込み) | 値型 / `var` で可変 |
| Dafny | `datatype` (名前付き) | `datatype` | ✅ 直接 | 自作 or `Std.Wrappers` | 再帰で書く | `map<K, V>` (組込み) | 不変 (class だけ可変) |
| Rust no_std | `struct` | `enum` | ⚠️ 参照 + ライフタイム (Box は alloc) | `Option` | イテレータ (core) | ❌ core / `BTreeMap` は alloc | 可変 |
| Zig | `struct` (既定値可) | `enum` / `union(enum)` | ⚠️ 自己参照ポインタ | `?T` | `for` で書く | `StringHashMap` (アロケータ必須) | 可変 |
| Gleam | カスタム型 (ラベル付き) | カスタム型 | ✅ 直接 | `Option` / `Result` | `list.map` / `fold` / `find` | `Dict` (組込み、不変) | 不変 |
| Koka | `struct` (アクセサ関数) | `type` | ✅ 直接 (`div` 効果が付く) | `maybe` | `map` / `filter` / `foldl` | 連想リスト (標準に Map は薄い) | 不変 (Perceus で in-place 最適化) |

## 言語ごとのコード

題材は共通で「`Item` (在庫) の一覧を集計する」と「`Expr` (数式) の再帰評価」。

### MoonBit → [examples](../moonbit/examples/03-data/)

```moonbit
pub(all) enum Expr { Num(Int); Add(Expr, Expr); Mul(Expr, Expr) } derive(Debug)

pub fn eval(e : Expr) -> Int {
  match e {
    Num(n) => n
    Add(a, b) => eval(a) + eval(b)
    Mul(a, b) => eval(a) * eval(b)
  }
}

pub fn value_by_category(items : Array[Item]) -> Map[Category, Int] {
  let m : Map[Category, Int] = Map::new()
  for i in items {
    m[i.category] = m.get(i.category).unwrap_or(0) + i.price * i.qty
  }
  m
}
```

`derive(Eq, Hash, Show, Debug)` で Map のキーとテスト比較の両方に対応。`inspect` でスナップショットテスト。

### OxCaml → [examples](../oxcaml/examples/03-data/)

```ocaml
type expr = Num of int | Add of expr * expr | Mul of expr * expr

let rec eval = function
  | Num n -> n
  | Add (a, b) -> eval a + eval b
  | Mul (a, b) -> eval a * eval b

module CatMap = Map.Make (struct type t = category let compare = compare end)
```

Map はファンクタで型ごとに生成。OxCaml では `float#` / `#(int * int)` の unboxed 型でレコードの割り当てを減らせる。

### Lean 4 → [examples](../lean/examples/03-data/)

```lean
inductive Expr where
  | num : Int → Expr
  | add : Expr → Expr → Expr
  | mul : Expr → Expr → Expr

def Expr.eval : Expr → Int
  | .num n => n
  | .add a b => a.eval + b.eval
  | .mul a b => a.eval * b.eval

theorem totalValue_singleton (i : Item) : totalValue [i] = i.price * i.qty := by simp [totalValue]
```

再帰の停止性を自動で確認。データ構造の性質を `decide` (具体値) と `theorem` (一般) で証明できる。

### Quint → [examples](../quint/examples/03-data/)

```quint
// 再帰型は書けない。深さを固定する
type Expr = Add({ a: int, b: int }) | Mul({ a: int, b: int })

pure def valueByCategory(items: List[Item]): Category -> int =
  items.foldl(Map(Food -> 0, Tool -> 0), (m, i) =>
    m.setBy(i.category, v => v + i.price * i.qty))

pure def find(items: List[Item], name: str): Set[Item] =   // Option の代わりに Set
  items.select(i => i.name == name).foldl(Set(), (acc, i) => acc.union(Set(i)))
```

有限状態を検査する言語なので再帰型がない。Option も無く「候補の Set」で表す。

### Verse → [examples](../verse/examples/03-data/) (UEFN 未確認)

```verse
expr := class:
    Eval<public>():int = 0
add := class(expr):
    L:expr
    R:expr
    Eval<override>():int = L.Eval() + R.Eval()

InStock(Items:[]item):[]item =
    for (I : Items, I.Qty > 0) { I }
```

代数的データ型がなく、再帰構造はクラス継承 + 仮想メソッド。`for` 式が map + filter を兼ねる。

### Dafny → [examples](../dafny/examples/03-data/)

```dafny
datatype Expr = Num(n: int) | Add(l: Expr, r: Expr) | Mul(l: Expr, r: Expr)

function TotalValue(items: seq<Item>): nat
{
  if |items| == 0 then 0
  else items[0].price * items[0].qty + TotalValue(items[1..])
}

lemma FilterKeepsValue(items: seq<Item>)
  ensures TotalValue(Filter(items)) == TotalValue(items)
{ }
```

`seq` / `set` / `map` は数学の列・集合・写像。filter しても合計が変わらないことを lemma で自動証明。

### Rust (no_std) → [examples](../rust-no-std/examples/03-data/)

```rust
pub enum Expr<'a> {
    Num(i64),
    Add(&'a Expr<'a>, &'a Expr<'a>),   // Box は alloc が要るので参照で
    Mul(&'a Expr<'a>, &'a Expr<'a>),
}

pub fn value_by_category(items: &[Item]) -> [u32; 2] {   // Map の代わりに enum をインデックスに
    let mut acc = [0u32; 2];
    for i in items { acc[i.category as usize] += i.price * i.qty; }
    acc
}
```

`Vec` / `Box` / `BTreeMap` は `alloc`、`HashMap` は `std` 限定。ヒープなしでは参照と固定長配列で組む。

### Zig → [examples](../zig/examples/03-data/)

```zig
const Expr = union(enum) {
    num: i64,
    add: [2]*const Expr,
    mul: [2]*const Expr,
};

fn namesSorted(alloc: std.mem.Allocator, items: []const Item) ![][]const u8 {
    var list: std.ArrayList([]const u8) = .empty;
    for (items) |i| try list.append(alloc, i.name);
    return list.toOwnedSlice(alloc);
}
```

tagged union が代数的データ型。ヒープを使う構造はすべて `Allocator` を受け取り、`defer` で解放する。`testing.allocator` がリークを検出する。

### Gleam → [examples](../gleam/examples/03-data/)

```gleam
pub type Expr {
  Num(Int)
  Add(Expr, Expr)
  Mul(Expr, Expr)
}

pub fn value_by_category(items: List(Item)) -> Dict(Category, Int) {
  list.fold(items, dict.new(), fn(acc, i) {
    dict.upsert(acc, i.category, fn(cur) { option.unwrap(cur, 0) + i.price * i.qty })
  })
}
```

すべて不変。`Item(..i, qty: 0)` で更新した新しい値を返す。`[first, ..rest]` でリストを分解。

### Koka → [examples](../koka/examples/03-data/)

```koka
type expr
  Num(n : int)
  Add(l : expr, r : expr)
  Mul(l : expr, r : expr)

fun eval(e : expr) : div int
  match e
    Num(n) -> n
    Add(l, r) -> eval(l) + eval(r)
    Mul(l, r) -> eval(l) * eval(r)
```

再帰関数には `div` (発散しうる) 効果が付く。struct のフィールドはアクセサ関数になり、`i(qty = 0)` でコピー更新。

## 違いはどこから来るか

1. **再帰型を「どう置くか」**。GC 言語 (MoonBit, OCaml, Lean, Dafny, Gleam, Koka) は直接書ける。Rust no_std と Zig はポインタと所有を明示する。Quint は無限の構造を排除し、Verse は継承で表す。
2. **不変か可変か**。検証系 (Lean, Quint, Dafny) と BEAM / 効果系 (Gleam, Koka) は不変が基本で、「更新」は新しい値を返す。システム系 (MoonBit, Rust, Zig, Verse) は可変が基本。OCaml は両方持つ。
3. **Map をどう提供するか**。組込みリテラル (MoonBit, Quint, Verse, Dafny)、ファンクタ (OCaml)、標準ライブラリ (Lean, Gleam, Rust alloc, Zig)、無し (Rust core)。Zig はアロケータを渡す点が独特。
4. **Option の有無**。無い言語 (Quint, Dafny) は和型で自作するか集合で代用する。仕様記述では「候補の集合」の方が自然。
5. **データ構造の性質を証明できるか**。Lean と Dafny は「filter しても合計が変わらない」を証明できる。他はテストで確認する。

## どれを選ぶか

| こういう人 | この言語 |
|---|---|
| 代数的データ型 + パターンマッチを気持ちよく書きたい | OxCaml, MoonBit, Lean |
| データ構造の性質まで証明したい | Dafny (自動), Lean (手動) |
| ヒープなしでデータ構造を組む訓練をしたい | Rust no_std, Zig |
| 不変データ + パターンマッチを小さな言語で学びたい | Gleam |
| 集合と写像で「設計」を書きたい | Quint, Dafny |
