///|
/// 列挙型 (ペイロードなし)。derive で比較・ハッシュ・デバッグ表示を自動実装 (Map のキーにするには Hash が必要)
pub(all) enum Category {
  Food
  Tool
} derive(Eq, Hash, Show, Debug)

///|
/// 構造体 (レコード)
pub(all) struct Item {
  name : String
  price : Int
  qty : Int
  category : Category
} derive(Eq, Debug)

///|
/// 再帰的な代数的データ型。GC があるので Box なしでそのまま再帰できる
pub(all) enum Expr {
  Num(Int)
  Add(Expr, Expr)
  Mul(Expr, Expr)
} derive(Debug)

///|
/// 再帰的なパターンマッチで評価する
pub fn eval(e : Expr) -> Int {
  match e {
    Num(n) => n
    Add(a, b) => eval(a) + eval(b)
    Mul(a, b) => eval(a) * eval(b)
  }
}

///|
/// Array と map / filter / fold
pub fn total_value(items : Array[Item]) -> Int {
  items.map(i => i.price * i.qty).fold(init=0, (acc, v) => acc + v)
}

///|
pub fn in_stock(items : Array[Item]) -> Array[Item] {
  items.filter(i => i.qty > 0)
}

///|
/// Option を返す検索
pub fn find(items : Array[Item], name : String) -> Item? {
  items.search_by(i => i.name == name).map(idx => items[idx])
}

///|
/// 配列のパターンマッチ: 先頭要素と残り
pub fn first_name(items : Array[Item]) -> String? {
  match items {
    [] => None
    [head, ..] => Some(head.name)
  }
}

///|
/// Map でカテゴリ別に集計
pub fn value_by_category(items : Array[Item]) -> Map[Category, Int] {
  let m : Map[Category, Int] = Map::new()
  for i in items {
    let cur = m.get(i.category).unwrap_or(0)
    m[i.category] = cur + i.price * i.qty
  }
  m
}

///|
pub fn sample() -> Array[Item] {
  [
    { name: "apple", price: 100, qty: 3, category: Food },
    { name: "hammer", price: 1500, qty: 0, category: Tool },
    { name: "bread", price: 200, qty: 2, category: Food },
  ]
}

///|
test "expr" {
  // (1 + 2) * 4
  let e = Mul(Add(Num(1), Num(2)), Num(4))
  assert_eq(eval(e), 12)
}

///|
test "arrays" {
  let items = sample()
  assert_eq(total_value(items), 700)
  assert_eq(in_stock(items).length(), 2)
  assert_eq(find(items, "bread").map(i => i.qty), Some(2))
  assert_eq(find(items, "milk"), None)
  assert_eq(first_name(items), Some("apple"))
  assert_eq(first_name([]), None)
}

///|
test "map" {
  let m = value_by_category(sample())
  assert_eq(m.get(Food), Some(700))
  assert_eq(m.get(Tool), Some(0))
  // スナップショットテスト: 初回は `moon test --update` で期待値を書き込む
  inspect(m, content="{Food: 700, Tool: 0}")
}
