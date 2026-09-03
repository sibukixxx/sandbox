/-! データ構造とパターンマッチ。題材: 在庫 (Item) と数式 (Expr) の評価器。 -/

/-- 列挙型 (ペイロードなし)。`deriving` で比較・表示を自動実装 -/
inductive Category where
  | food
  | tool
  deriving Repr, DecidableEq, BEq

/-- 構造体 (レコード) -/
structure Item where
  name : String
  price : Nat
  qty : Nat
  category : Category
  deriving Repr, BEq

/-- 再帰的な帰納型。Lean は再帰が「小さくなる」ことを自動で確認する -/
inductive Expr where
  | num : Int → Expr
  | add : Expr → Expr → Expr
  | mul : Expr → Expr → Expr
  deriving Repr

/-- 再帰的なパターンマッチで評価する。停止性は構造的再帰なので自動証明される -/
def Expr.eval : Expr → Int
  | .num n => n
  | .add a b => a.eval + b.eval
  | .mul a b => a.eval * b.eval

/-- List の map / filter / foldl -/
def totalValue (items : List Item) : Nat :=
  items.map (fun i => i.price * i.qty) |>.foldl (· + ·) 0

def inStock (items : List Item) : List Item :=
  items.filter (fun i => i.qty > 0)

/-- Option を返す検索 -/
def find (items : List Item) (name : String) : Option Item :=
  items.find? (fun i => i.name == name)

/-- リストのパターンマッチ: 先頭要素と残り -/
def firstName : List Item → Option String
  | [] => none
  | head :: _ => some head.name

/-- 連想リストで「カテゴリ別の集計」。Std.HashMap もあるが、小さければ List で十分 -/
def valueByCategory (items : List Item) : List (Category × Nat) :=
  let add (acc : List (Category × Nat)) (i : Item) : List (Category × Nat) :=
    let v := i.price * i.qty
    match acc.find? (·.1 == i.category) with
    | some _ => acc.map (fun (c, n) => if c == i.category then (c, n + v) else (c, n))
    | none => acc ++ [(i.category, v)]
  items.foldl add []

def sample : List Item := [
  { name := "apple", price := 100, qty := 3, category := .food },
  { name := "hammer", price := 1500, qty := 0, category := .tool },
  { name := "bread", price := 200, qty := 2, category := .food }
]

-- 具体値の検査は `decide` (計算して確認)
example : Expr.eval (.mul (.add (.num 1) (.num 2)) (.num 4)) = 12 := by decide
example : totalValue sample = 700 := by decide
example : (inStock sample).length = 2 := by decide
example : (find sample "bread").map (·.qty) = some 2 := by decide
example : find sample "milk" = none := by decide
example : firstName sample = some "apple" := by decide
example : firstName [] = none := by decide
example : valueByCategory sample = [(.food, 700), (.tool, 0)] := by decide

-- データ構造についての一般的な性質も証明できる。
-- 「空リストの合計は 0」「1 要素の合計はその要素の価値」
theorem totalValue_nil : totalValue [] = 0 := rfl
theorem totalValue_singleton (i : Item) : totalValue [i] = i.price * i.qty := by
  simp [totalValue]
