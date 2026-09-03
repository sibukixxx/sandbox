// データ構造とパターンマッチ。題材: 在庫 (Item) と数式 (Expr)。
// Quint のデータ型: int, str, bool, Set, List, Map, レコード, 和型, タプル。

module data {
  // 和型 (ペイロードなし)
  type Category = Food | Tool

  // レコード型
  type Item = { name: str, price: int, qty: int, category: Category }

  // 再帰的な和型は定義できない (Quint は有限状態を扱う言語なので意図的に無い)。
  // 数式は「深さを固定した」形で表す。コンストラクタの引数は 1 つなのでレコードにまとめる。
  type Expr = Add({ a: int, b: int }) | Mul({ a: int, b: int })

  pure def eval(e: Expr): int =
    match e {
      | Add(r) => r.a + r.b
      | Mul(r) => r.a * r.b
    }

  // List の map / select (filter) / foldl
  pure def totalValue(items: List[Item]): int =
    items.foldl(0, (acc, i) => acc + i.price * i.qty)

  pure def inStock(items: List[Item]): List[Item] =
    items.select(i => i.qty > 0)

  // 検索: 見つかった要素の Set を返す (Option がないので Set で表す定石)
  pure def find(items: List[Item], name: str): Set[Item] =
    items.select(i => i.name == name).foldl(Set(), (acc, i) => acc.union(Set(i)))

  // List の先頭: head は空リストに対してエラーになるので length で守る
  pure def firstName(items: List[Item]): Set[str] =
    if (items.length() == 0) Set() else Set(items.head().name)

  // Map でカテゴリ別に集計。Map は不変で、put / setBy で新しい Map を返す
  pure def valueByCategory(items: List[Item]): Category -> int =
    items.foldl(Map(Food -> 0, Tool -> 0), (m, i) =>
      m.setBy(i.category, v => v + i.price * i.qty))

  // Set 内包表記。仕様記述では「全ての組み合わせ」を Set で列挙することが多い
  pure def namesInStock(items: List[Item]): Set[str] =
    inStock(items).foldl(Set(), (acc, i) => acc.union(Set(i.name))).map(n => n)

  pure val sample: List[Item] = [
    { name: "apple", price: 100, qty: 3, category: Food },
    { name: "hammer", price: 1500, qty: 0, category: Tool },
    { name: "bread", price: 200, qty: 2, category: Food },
  ]

  run exprTest = all {
    assert(eval(Add({ a: 1, b: 2 })) == 3),
    assert(eval(Mul({ a: 3, b: 4 })) == 12),
  }

  run listTest = all {
    assert(totalValue(sample) == 700),
    assert(inStock(sample).length() == 2),
    assert(find(sample, "bread").map(i => i.qty) == Set(2)),
    assert(find(sample, "milk") == Set()),
    assert(firstName(sample) == Set("apple")),
    assert(firstName([]) == Set()),
    assert(namesInStock(sample) == Set("apple", "bread")),
  }

  run mapTest = all {
    assert(valueByCategory(sample).get(Food) == 700),
    assert(valueByCategory(sample).get(Tool) == 0),
    assert(valueByCategory(sample).keys() == Set(Food, Tool)),
  }
}
