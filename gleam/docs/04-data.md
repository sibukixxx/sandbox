# 04. データ構造

対応サンプル: [`examples/03-data/`](../examples/03-data/)

## 目的

カスタム型、リスト、Dict を不変データとして扱い、パターンマッチで分解する。

## 最小コード

```gleam
pub type Item {
  Item(name: String, price: Int, qty: Int, category: Category)
}

pub type Expr {
  Num(Int)
  Add(Expr, Expr)
  Mul(Expr, Expr)
}

pub fn eval(e: Expr) -> Int {
  case e {
    Num(n) -> n
    Add(a, b) -> eval(a) + eval(b)
    Mul(a, b) -> eval(a) * eval(b)
  }
}

pub fn value_by_category(items: List(Item)) -> Dict(Category, Int) {
  list.fold(items, dict.new(), fn(acc, i) {
    dict.upsert(acc, i.category, fn(cur) { option.unwrap(cur, 0) + i.price * i.qty })
  })
}
```

## 解説

### カスタム型

| 種類 | 書き方 | 備考 |
|---|---|---|
| 列挙 | `type Category { Food Tool }` | ペイロードなしのコンストラクタ |
| レコード | `type Item { Item(name: String, ...) }` | 1 コンストラクタ + ラベル付きフィールド。`i.name` で参照 |
| 和型 | `type Expr { Num(Int) Add(Expr, Expr) }` | 再帰も可 |
| 更新 | `Item(..i, qty: 0)` | 新しい値を返す (元は変わらない) |

`struct` と `enum` の区別はなく、すべて「カスタム型」。

### List と Dict

- `List(a)` は連結リスト。`[first, ..rest]` でパターンマッチ。`list.map` / `filter` / `fold` / `find`。
- `Dict(k, v)` は不変のハッシュマップ。`dict.get` は `Result`、`dict.upsert` は「なければ挿入、あれば更新」。
- タプル `#(a, b)` は `.0` / `.1` で参照。

### let assert

```gleam
let assert [apple, ..] = sample
```

パターンが必ず成功すると分かっているときに使う。失敗すると実行時にクラッシュする (BEAM の let it crash に沿う)。

## 他の言語ではこう書く

Elixir の struct + パターンマッチに型が付いたもの。Rust と違い `Box` は不要 (GC)。
`Option` は `gleam/option`、`Result` は組込みで、`option.from_result` などで変換する。

## 落とし穴

- `dict.to_list` の順序は不定。表示するときはソートする。
- レコードのフィールドアクセス `i.name` は、その型の全コンストラクタが同じ位置に同名フィールドを持つときだけ使える。
- `pub const` に置けるのはリテラルと定数式だけ。
