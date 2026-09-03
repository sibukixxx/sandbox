# 04. データ構造

対応サンプル: [`examples/03-data/`](../examples/03-data/)

## 目的

`datatype` / `seq` / `set` / `map` の使い方と、データ構造の性質を `lemma` で証明することを体験する。

## 最小コード

```dafny
datatype Category = Food | Tool
datatype Item = Item(name: string, price: nat, qty: nat, category: Category)
datatype Expr = Num(n: int) | Add(l: Expr, r: Expr) | Mul(l: Expr, r: Expr)

function Eval(e: Expr): int
{
  match e
  case Num(n) => n
  case Add(l, r) => Eval(l) + Eval(r)
  case Mul(l, r) => Eval(l) * Eval(r)
}

function TotalValue(items: seq<Item>): nat
{
  if |items| == 0 then 0
  else items[0].price * items[0].qty + TotalValue(items[1..])
}
```

## 解説

### 型の一覧

| 型 | 書き方 | 主な操作 |
|---|---|---|
| `datatype` | `Item(name: string, ...)` | `i.name`, `i.Item?`, `match` |
| `seq<T>` | `[1, 2]` | `\|s\|`, `s[0]`, `s[1..]`, `s + t`, `x in s` |
| `set<T>` | `{1, 2}` | `+` (和), `*` (積), `-` (差), `x in s`, 内包 `set x \| x in s :: f(x)` |
| `map<K, V>` | `map[k := v]` | `m[k]`, `k in m`, `m[k := v]` (更新した新しい map) |
| `string` | `"abc"` | `seq<char>` の別名 |
| `class` | 参照型、可変 | 章 5 で扱う (`modifies` が必要) |

`datatype` / `seq` / `set` / `map` はすべて **不変** (値型)。可変が必要なときだけ `class` / `array` を使う。

### 再帰関数と停止性

`seq` に対する再帰は `items[1..]` で短くなるので、停止性は自動で証明される。
自動で分からないときは `decreases |items|` を明示する。

### Option

標準ライブラリに `Std.Wrappers.Option` があるが、`datatype Option<T> = Some(value: T) | None` と自作しても数行。

### データ構造の性質を証明する

```dafny
lemma FilterInStock(items: seq<Item>)
  ensures forall i :: i in Filter(items) ==> i.qty > 0
{ }

lemma FilterKeepsValue(items: seq<Item>)
  ensures TotalValue(Filter(items)) == TotalValue(items)
{ }
```

`forall` は全称量化。再帰的な関数についての lemma は帰納法が必要だが、Dafny は lemma 本体を再帰呼び出し (帰納法の仮定) なしでも多くの場合自動で証明する。
自動で通らないときは `FilterKeepsValue(items[1..]);` のように lemma を再帰呼び出しして帰納法の仮定を与える。

## 他の言語ではこう書く

`seq` / `set` / `map` は数学の列・集合・写像そのもので、Quint とほぼ同じ語彙。
Rust の `Vec` と違い、`seq` は不変なので「更新」は常に新しい値を返す。

## 落とし穴

- `string` は `seq<char>` なので、`--target:js` で `print` すると文字のリストとして表示されることがある。
- `seq(n, i => f(i))` 内包表記は「要素数が先に決まる」場合にしか使えない。filter は再帰で書く。
- `set` の内包表記は、要素の集合が有限であることを Dafny が確認できる形 (`x in s`) でなければならない。
