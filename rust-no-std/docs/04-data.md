# 04. データ構造

対応サンプル: [`examples/03-data/`](../examples/03-data/)

## 目的

ヒープなし (`core` だけ) でどこまでデータ構造を扱えるか、`alloc` を足すと何が増えるかを知る。

## 最小コード

```rust
#[derive(Debug, Clone, Copy, PartialEq)]
pub struct Item { pub name: &'static str, pub price: u32, pub qty: u32, pub category: Category }

#[derive(Debug, Clone, Copy)]
pub enum Expr<'a> {
    Num(i64),
    Add(&'a Expr<'a>, &'a Expr<'a>),
    Mul(&'a Expr<'a>, &'a Expr<'a>),
}

pub fn eval(e: &Expr) -> i64 {
    match e {
        Expr::Num(n) => *n,
        Expr::Add(a, b) => eval(a) + eval(b),
        Expr::Mul(a, b) => eval(a) * eval(b),
    }
}

pub fn total_value(items: &[Item]) -> u32 {
    items.iter().map(|i| i.price * i.qty).sum()
}
```

## 解説

### core にあるもの

| データ構造 | `core` | 備考 |
|---|---|---|
| `struct` / `enum` / タプル | ✅ | `derive` も使える |
| 固定長配列 `[T; N]`、スライス `&[T]` | ✅ | イテレータ (`map`, `filter`, `sum`, `find`) も core |
| `Option` / `Result` | ✅ | |
| `&str` | ✅ | `String` は alloc |
| `Vec`, `String`, `Box`, `BTreeMap` | ❌ → `alloc` | |
| `HashMap` | ❌ → `std` のみ | ハッシュのシードに OS の乱数が要るため |

### 再帰的なデータ構造を Box なしで

`Box<Expr>` は `alloc` が要る。参照 + ライフタイム (`&'a Expr<'a>`) にすれば、ノードをスタックや static に置いて木を作れる。
サンプルではテスト内でノードをローカル変数として作り、参照で繋いでいる。

### Map の代わり

enum を `as usize` でインデックスにした固定長配列 `[u32; 2]` で「カテゴリ別集計」ができる。キーの種類が有限ならこれで十分。
可変長が必要なら `heapless::FnvIndexMap` (固定容量) か、`alloc` の `BTreeMap`。

### スライスパターン

```rust
match items {
    [] => None,
    [head, ..] => Some(head.name),
}
```

### alloc を足す

```rust
#[cfg(feature = "alloc")]
extern crate alloc;
use alloc::vec::Vec;
use alloc::collections::BTreeMap;
```

`Vec` / `String` / `BTreeMap` が使えるようになる。ただし `#[global_allocator]` を用意しないとリンクに失敗する (ホスト上のテストでは std が提供する)。

## 他の言語ではこう書く

OCaml や MoonBit は GC があるので `Add(Expr, Expr)` と直接書ける。Rust `no_std` では「誰がそのノードを所有するか」を明示する必要がある。

## 落とし穴

- `#[derive(Debug)]` は core で使えるが、`{:?}` で表示するには `core::fmt::Write` の実装先が要る。
- `f32::abs` などの一部の浮動小数点関数は `core` にない。整数で済ませるか `libm` を使う。
- `sort` は `alloc` (Vec のメソッド)。スライスには `sort_unstable` が core にある。
