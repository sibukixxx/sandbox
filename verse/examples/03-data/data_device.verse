# データ構造。題材: 在庫 (item) と数式 (expr) の評価器。
# Verse のデータ型: int / float / string / logic, array, map, tuple, option, class, struct, enum。

using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# enum (ペイロードなし)
category := enum:
    Food
    Tool

# struct: 値型のレコード。クラスと違い参照ではなくコピーされる
item := struct:
    Name:string
    Price:int
    Qty:int
    Category:category

# 再帰的なデータ型はクラスの継承で表す (代数的データ型はない)
expr := class:
    Eval<public>():int = 0

num := class(expr):
    N:int
    Eval<override>():int = N

add := class(expr):
    L:expr
    R:expr
    Eval<override>():int = L.Eval() + R.Eval()

mul := class(expr):
    L:expr
    R:expr
    Eval<override>():int = L.Eval() * R.Eval()

# 配列の走査。for 式は配列を返す (map に相当)
TotalValue(Items:[]item):int =
    var Sum:int = 0
    for (I : Items):
        set Sum += I.Price * I.Qty
    Sum

# for + 失敗コンテキストで filter
InStock(Items:[]item):[]item =
    for (I : Items, I.Qty > 0) { I }

# option を返す検索。見つかった最初の要素
Find(Items:[]item, Name:string):?item =
    var Found:?item = false
    for (I : Items, I.Name = Name, not Found?):
        set Found = option{I}
    Found

# 配列の添字アクセスは失敗しうる式 (範囲外で失敗)
FirstName(Items:[]item):?string =
    if (First := Items[0]) then option{First.Name} else false

# map: [キー型]値型。更新は set M[K] = V (失敗しうる)
ValueByCategory(Items:[]item)<transacts>:[category]int =
    var M:[category]int = map{category.Food => 0, category.Tool => 0}
    for (I : Items):
        if (Cur := M[I.Category]):
            if (set M[I.Category] = Cur + I.Price * I.Qty) {}
    M

data_device := class(creative_device):

    OnBegin<override>()<suspends>:void =
        Sample:[]item = array{
            item{Name := "apple", Price := 100, Qty := 3, Category := category.Food},
            item{Name := "hammer", Price := 1500, Qty := 0, Category := category.Tool},
            item{Name := "bread", Price := 200, Qty := 2, Category := category.Food}
        }
        E := mul{L := add{L := num{N := 1}, R := num{N := 2}}, R := num{N := 4}}
        Print("(1 + 2) * 4 = {E.Eval()}")
        Print("total: {TotalValue(Sample)}")
        Print("in stock: {InStock(Sample).Length}")
        if (Bread := Find(Sample, "bread")?):
            Print("find bread: qty={Bread.Qty}")
        if (not Find(Sample, "milk")?):
            Print("find milk: none")
        if (First := FirstName(Sample)?):
            Print("first: {First}")
        M := ValueByCategory(Sample)
        if (Food := M[category.Food], Tool := M[category.Tool]):
            Print("Food: {Food}, Tool: {Tool}")
