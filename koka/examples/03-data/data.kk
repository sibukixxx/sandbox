// データ構造とパターンマッチ。題材: 在庫 (item) と数式 (expr) の評価器。

// 列挙型 (ペイロードなし)
type category
  Food
  Tool

// struct = 1 コンストラクタの型。フィールドはアクセサ関数になる (i.name)
struct item
  name : string
  price : int
  qty : int
  category : category

// 再帰的な代数的データ型
type expr
  Num(n : int)
  Add(l : expr, r : expr)
  Mul(l : expr, r : expr)

// 再帰的なパターンマッチ。Koka は停止性を検査しない (div 効果が付く)
fun eval(e : expr) : div int
  match e
    Num(n) -> n
    Add(l, r) -> eval(l) + eval(r)
    Mul(l, r) -> eval(l) * eval(r)

// list の map / filter / foldl
fun total-value(items : list<item>) : int
  items.map(fn(i) i.price * i.qty).foldl(0, (+))

fun in-stock(items : list<item>) : list<item>
  items.filter(fn(i) i.qty > 0)

// maybe を返す検索
fun find-item(items : list<item>, target : string) : maybe<item>
  items.find(fn(i) i.name == target)   // 引数名を name にすると accessor の name と衝突する

// リストのパターンマッチ: Cons / Nil
fun first-name(items : list<item>) : maybe<string>
  match items
    Nil -> Nothing
    Cons(head, _) -> Just(head.name)

// 連想リストでカテゴリ別に集計。category に (==) を定義する
fun (==)(a : category, b : category) : bool
  match (a, b)
    (Food, Food) -> True
    (Tool, Tool) -> True
    _ -> False

fun show(c : category) : string
  match c
    Food -> "Food"
    Tool -> "Tool"

// 最後の引数が関数なら、括弧の外に `fn` を書ける (trailing lambda)
fun value-by-category(items : list<item>) : list<(category, int)>
  items.foldl([]) fn(acc, i)
    val v = i.price * i.qty
    if acc.any(fn(p) p.fst == i.category)
      then acc.map(fn(p) if p.fst == i.category then (p.fst, p.snd + v) else p)
      else acc ++ [(i.category, v)]

// struct のコピー更新: `i(qty = 0)`
fun sold-out(i : item) : item
  i(qty = 0)

val sample = [
  Item("apple", 100, 3, Food),
  Item("hammer", 1500, 0, Tool),
  Item("bread", 200, 2, Food)
]

fun main()
  val e = Mul(Add(Num(1), Num(2)), Num(4))
  println("(1 + 2) * 4 = " ++ eval(e).show)
  println("total: " ++ total-value(sample).show)
  println("in stock: " ++ in-stock(sample).map(name).join(", "))
  match find-item(sample, "bread")
    Just(b) -> println("find bread: qty=" ++ b.qty.show)
    Nothing -> println("find bread: none")
  println("find milk: " ++ find-item(sample, "milk").map(name).show)
  println("first: " ++ first-name(sample).show)
  value-by-category(sample).foreach fn((c, v))
    println(c.show ++ ": " ++ v.show)
  println("sold out apple qty: " ++ sample.head(Item("", 0, 0, Food)).sold-out.qty.show)
