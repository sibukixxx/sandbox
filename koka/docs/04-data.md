# 04. データ構造

対応サンプル: [`examples/03-data/`](../examples/03-data/)

## 目的

`type` / `struct` とリスト操作、自分の型への `show` / `(==)` の定義を学ぶ。

## 最小コード

```koka
type category
  Food
  Tool

struct item
  name : string
  price : int
  qty : int
  category : category

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

## 解説

### 型の定義

| 種類 | 書き方 | 備考 |
|---|---|---|
| 列挙・和型 | `type t` + コンストラクタの列 | コンストラクタは大文字始まり |
| struct | `struct item` + フィールド | 1 コンストラクタの type の省略形。`Item(...)` で生成 |
| 再帰型 | `Add(l : expr, r : expr)` | そのまま再帰できる |
| タプル | `(1, "a")` | `.fst` / `.snd` |

struct のフィールドはアクセサ関数になる (`i.name` = `name(i)`)。コピー更新は `i(qty = 0)`。

### div 効果

再帰関数は停止性を検査されず、`div` (発散しうる) 効果が付く。`eval` の型が `div int` なのはそのため。停止することが分かっていても付く (構造的再帰なら Koka が `total` と推論する場合もある)。

### リスト

`list<a>` は `Cons` / `Nil`。`[1, 2, 3]` リテラル。`map`, `filter`, `foldl`, `find`, `any`, `foreach`, `join` などは `std/core`。

### show と (==)

自分の型に `show` や `(==)` を定義すれば、ドット記法や `==` で使える。標準の `show` と曖昧になる場合はモジュール名で修飾する。

### trailing lambda

最後の引数が関数なら `items.foldl([]) fn(acc, i) ...` と括弧の外に書ける。複数行の関数を渡すときに読みやすい。

## 他の言語ではこう書く

OCaml のバリアントとレコードに近い。struct のフィールドが関数になる点、`with` 構文 (章 5) でネストを平らにする点が Koka らしい。

## 落とし穴

- 引数名がアクセサ (`name`) と同じだと、`i.name` が引数を指してしまう。引数名を変える。
- `float64` を使うには `import std/num/float64`。
- `val` は予約語。
