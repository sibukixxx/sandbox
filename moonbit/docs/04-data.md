# 04. データ構造

対応サンプル: [`examples/03-data/`](../examples/03-data/)

## 目的

`struct` / `enum` / `Array` / `Map` と、`derive` で何が自動実装されるかを知る。

## 最小コード

```moonbit
pub(all) enum Category {
  Food
  Tool
} derive(Eq, Hash, Show, Debug)

pub(all) struct Item {
  name : String
  price : Int
  qty : Int
  category : Category
} derive(Eq, Debug)

pub(all) enum Expr {
  Num(Int)
  Add(Expr, Expr)
  Mul(Expr, Expr)
} derive(Debug)

pub fn eval(e : Expr) -> Int {
  match e {
    Num(n) => n
    Add(a, b) => eval(a) + eval(b)
    Mul(a, b) => eval(a) * eval(b)
  }
}
```

## 解説

### derive

| trait | 何ができるか | 必要になる場面 |
|---|---|---|
| `Eq` | `==` | `assert_eq` |
| `Hash` | ハッシュ | `Map` のキー |
| `Show` | `to_string()` / 文字列補間 | `println`、`Map` の表示 |
| `Debug` | デバッグ表示 | `assert_eq` / `inspect` の失敗時表示 |
| `Compare` | `<` など | ソート |

`Map[Category, Int]` のキーにするには `Eq` + `Hash`、テストで比較するには `Debug` が要る。

### コレクション

| 型 | 生成 | 主な操作 |
|---|---|---|
| `Array[T]` | `[1, 2, 3]` | `map`, `filter`, `fold(init=, f)`, `search_by`, `length` |
| `Map[K, V]` | `Map::new()`, `{ "a": 1 }` | `m[k] = v`, `m.get(k)` (Option), `m.contains(k)` |
| `T?` | `Some(v)` / `None` | `map`, `unwrap_or`, `match` |

`{}` は空 Map / 空ブロック / 空 struct のどれとも取れるので、空 Map は `Map::new()` と書く。

### パターンマッチ

- 配列: `[] => ...`, `[head, ..] => ...`, `[a, b] => ...`
- 再帰型: GC があるので `Add(Expr, Expr)` と直接書ける
- struct: `{ name, qty, .. } => ...`

### スナップショットテスト

```moonbit
inspect(m, content="{Food: 700, Tool: 0}")
```

`content` を空にして `moon test --update` を実行すると、実際の値が書き込まれる。

## 他の言語ではこう書く

Rust とほぼ同じだが、`derive` の trait 名 (`Show` / `Debug`) と `Map` が組込みリテラルを持つ点が違う。

## 落とし穴

- `Show` を派生していない型を含む `Map` は `inspect` できない (コンパイルエラー)。
- `Map` の反復順は挿入順 (linked hash map)。
