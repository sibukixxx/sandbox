// データ構造とパターンマッチ。題材: 在庫 (Item) と数式 (Expr) の評価器。
// Gleam のデータはすべて不変。更新は新しい値を返す。

import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string

/// カスタム型 (ペイロードなし) = 列挙
pub type Category {
  Food
  Tool
}

/// レコード = 1 コンストラクタでラベル付きフィールドを持つカスタム型
pub type Item {
  Item(name: String, price: Int, qty: Int, category: Category)
}

/// 再帰的なカスタム型
pub type Expr {
  Num(Int)
  Add(Expr, Expr)
  Mul(Expr, Expr)
}

/// 再帰的なパターンマッチ
pub fn eval(e: Expr) -> Int {
  case e {
    Num(n) -> n
    Add(a, b) -> eval(a) + eval(b)
    Mul(a, b) -> eval(a) * eval(b)
  }
}

/// list の map / fold。`|>` パイプで左から右に読む
pub fn total_value(items: List(Item)) -> Int {
  items
  |> list.map(fn(i) { i.price * i.qty })
  |> list.fold(0, int.add)
}

pub fn in_stock(items: List(Item)) -> List(Item) {
  list.filter(items, fn(i) { i.qty > 0 })
}

/// Result を返す検索を Option に変換
pub fn find(items: List(Item), name: String) -> Option(Item) {
  items
  |> list.find(fn(i) { i.name == name })
  |> option.from_result
}

/// リストのパターンマッチ: `[first, ..rest]`
pub fn first_name(items: List(Item)) -> Option(String) {
  case items {
    [] -> None
    [first, ..] -> Some(first.name)
  }
}

/// Dict でカテゴリ別に集計。dict.upsert で「なければ挿入、あれば更新」
pub fn value_by_category(items: List(Item)) -> Dict(Category, Int) {
  list.fold(items, dict.new(), fn(acc, i) {
    dict.upsert(acc, i.category, fn(cur) {
      case cur {
        None -> i.price * i.qty
        Some(v) -> v + i.price * i.qty
      }
    })
  })
}

/// レコードの更新構文: `Item(..i, qty: 0)`
pub fn sold_out(i: Item) -> Item {
  Item(..i, qty: 0)
}

pub const sample = [
  Item("apple", 100, 3, Food),
  Item("hammer", 1500, 0, Tool),
  Item("bread", 200, 2, Food),
]

fn category_to_string(c: Category) -> String {
  case c {
    Food -> "Food"
    Tool -> "Tool"
  }
}

pub fn main() -> Nil {
  let e = Mul(Add(Num(1), Num(2)), Num(4))
  io.println("(1 + 2) * 4 = " <> int.to_string(eval(e)))
  io.println("total: " <> int.to_string(total_value(sample)))
  io.println(
    "in stock: " <> string.join(list.map(in_stock(sample), fn(i) { i.name }), ", "),
  )
  case find(sample, "bread") {
    Some(b) -> io.println("find bread: qty=" <> int.to_string(b.qty))
    None -> io.println("find bread: none")
  }
  case find(sample, "milk") {
    Some(_) -> io.println("find milk: found")
    None -> io.println("find milk: none")
  }
  io.println("first: " <> option.unwrap(first_name(sample), "-"))
  value_by_category(sample)
  |> dict.to_list
  |> list.sort(fn(a, b) { string.compare(category_to_string(a.0), category_to_string(b.0)) })
  |> list.each(fn(p) {
    io.println(category_to_string(p.0) <> ": " <> int.to_string(p.1))
  })
  let assert [apple, ..] = sample
  io.println("sold out apple qty: " <> int.to_string(sold_out(apple).qty))
}
