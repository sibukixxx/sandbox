# 04. データ構造

対応サンプル: [`examples/03-data/`](../examples/03-data/)

## 目的

Quint のデータ型 (レコード、和型、List、Set、Map) と、「再帰的な型がない」理由を理解する。

## 最小コード

```quint
type Category = Food | Tool
type Item = { name: str, price: int, qty: int, category: Category }

pure def totalValue(items: List[Item]): int =
  items.foldl(0, (acc, i) => acc + i.price * i.qty)

pure def valueByCategory(items: List[Item]): Category -> int =
  items.foldl(Map(Food -> 0, Tool -> 0), (m, i) =>
    m.setBy(i.category, v => v + i.price * i.qty))
```

## 解説

### 型の一覧

| 型 | 書き方 | 主な操作 |
|---|---|---|
| レコード | `{ name: str, qty: int }` | `r.name`, `{ ...r, qty: 0 }` |
| 和型 | `Food \| Tool`, `Add({ a: int, b: int })` | `match e { \| Add(r) => ... }` |
| タプル | `(int, str)` | `t._1` |
| `List[T]` | `[1, 2]` | `foldl`, `select` (filter), `head`, `length`, `append` |
| `Set[T]` | `Set(1, 2)` | `union`, `contains`, `forall`, `exists`, `map`, `filter` |
| `Map[K, V]` | `Map(k -> v)`, 型は `K -> V` | `get`, `put`, `setBy`, `keys` |

すべて **不変**。`put` / `setBy` は新しい Map を返す。

### 再帰的な型がない

`type Expr = Num(int) | Add(Expr, Expr)` は書けない。Quint は有限の状態空間をモデル検査する言語なので、無限に大きくなりうる型を意図的に排除している。
木構造が必要なら「深さを固定する」か、ノードを `Map[int, Node]` で持ち ID で参照する。

### Option がない

「見つからないかもしれない」は **要素の Set** で表す (`Set()` が「なし」)。仕様記述では「候補の集合」として扱う方が自然なことが多い。

### Set が中心

仕様記述では List より Set を多用する。`Set(1, 2, 3).forall(x => x > 0)` や `xs.powerset()`、`a.cross(b)` など、数学の集合演算がそのまま書ける。

## 他の言語ではこう書く

OCaml / Rust の `enum` に近いが、コンストラクタは 1 引数 (レコードでまとめる)。
Map の型を `K -> V` (関数型) と書くのは TLA+ 由来。

## 落とし穴

- `head()` は空 List でエラー。`length()` で守る。
- `select` が filter に相当する (`filter` は Set 用)。
- レコードの型はフィールド名と型が完全一致する必要がある (行多相はない)。
