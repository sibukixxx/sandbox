// データ構造とパターンマッチ。題材: 在庫 (Item) と数式 (Expr) の評価器。
// Dafny のデータ型: int/nat/bool/string, seq, set, map, datatype, class, tuple。

// datatype (ペイロードなし)
datatype Category = Food | Tool

// datatype でレコード。フィールド名付きコンストラクタ
datatype Item = Item(name: string, price: nat, qty: nat, category: Category)

// 再帰的な datatype
datatype Expr = Num(n: int) | Add(l: Expr, r: Expr) | Mul(l: Expr, r: Expr)

// 再帰関数。Dafny は構造的再帰の停止性を自動で証明する
function Eval(e: Expr): int
{
  match e
  case Num(n) => n
  case Add(l, r) => Eval(l) + Eval(r)
  case Mul(l, r) => Eval(l) * Eval(r)
}

// seq に対する再帰。|s| は長さ、s[0] は先頭、s[1..] は残り
function TotalValue(items: seq<Item>): nat
{
  if |items| == 0 then 0
  else items[0].price * items[0].qty + TotalValue(items[1..])
}

// filter は再帰で書く (seq 内包表記 `seq(n, i => ...)` は要素数が先に決まるものにしか使えない)
function Filter(items: seq<Item>): seq<Item>
{
  if |items| == 0 then []
  else if items[0].qty > 0 then [items[0]] + Filter(items[1..])
  else Filter(items[1..])
}

// Option は datatype で定義する (標準ライブラリにも Std.Wrappers.Option がある)
datatype Option<T> = Some(value: T) | None

function Find(items: seq<Item>, name: string): Option<Item>
{
  if |items| == 0 then None
  else if items[0].name == name then Some(items[0])
  else Find(items[1..], name)
}

function FirstName(items: seq<Item>): Option<string>
{
  if |items| == 0 then None else Some(items[0].name)
}

// map<K, V>。m[k := v] で更新した新しい map を返す。k in m でキーの存在を検査
function ValueByCategory(items: seq<Item>): map<Category, nat>
{
  if |items| == 0 then map[]
  else
    var rest := ValueByCategory(items[1..]);
    var c := items[0].category;
    var v := items[0].price * items[0].qty;
    if c in rest then rest[c := rest[c] + v] else rest[c := v]
}

// set: 重複なし、順序なし。集合演算 (+, *, -) と内包表記
function NamesInStock(items: seq<Item>): set<string>
{
  set i | i in Filter(items) :: i.name
}

const Sample: seq<Item> := [
  Item("apple", 100, 3, Food),
  Item("hammer", 1500, 0, Tool),
  Item("bread", 200, 2, Food)
]

// --- 性質を仕様として書く ---

// filter の結果は全て在庫あり (全称量化 forall)
lemma FilterInStock(items: seq<Item>)
  ensures forall i :: i in Filter(items) ==> i.qty > 0
{
  // 再帰的な datatype / seq に対する lemma は帰納法で証明する。Dafny が自動で行う
}

// filter しても合計は変わらない (在庫 0 の価値は 0 なので寄与しない)
lemma FilterKeepsValue(items: seq<Item>)
  ensures TotalValue(Filter(items)) == TotalValue(items)
{
  // 帰納法。items[0].qty == 0 のとき価値は 0 なので合計に寄与しない
}

method Main() {
  var e := Mul(Add(Num(1), Num(2)), Num(4));
  print "(1 + 2) * 4 = ", Eval(e), "\n";
  print "total: ", TotalValue(Sample), "\n";
  print "in stock: ", |Filter(Sample)|, "\n";
  print "find bread: ", Find(Sample, "bread"), "\n";
  print "find milk: ", Find(Sample, "milk"), "\n";
  print "first: ", FirstName(Sample), "\n";
  print "by category: ", ValueByCategory(Sample), "\n";
  print "names: ", NamesInStock(Sample), "\n";
  assert Eval(e) == 12;
  assert TotalValue(Sample) == 700;
}
