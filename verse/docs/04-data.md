# 04. データ構造

対応サンプル: [`examples/03-data/`](../examples/03-data/)

## 目的

Verse の値型 / 参照型の区別と、配列・map・option が失敗コンテキストとどう結びつくかを知る。

## 最小コード

```verse
item := struct:
    Name:string
    Price:int

TotalValue(Items:[]item):int =
    var Sum:int = 0
    for (I : Items):
        set Sum += I.Price
    Sum

InStock(Items:[]item):[]item =
    for (I : Items, I.Qty > 0) { I }
```

## 解説

| 型 | 書き方 | 備考 |
|---|---|---|
| enum | `category := enum: Food, Tool` | ペイロードなし。`category.Food` で参照 |
| struct | `item := struct: Name:string` | 値型。代入でコピー。`item{Name := "a"}` で生成 |
| class | `expr := class: ...` | 参照型。継承と `<override>` |
| array | `[]item`、`array{a, b}` | `Items[0]` は失敗しうる (範囲外で失敗) |
| map | `[category]int`、`map{k => v}` | `M[K]` は失敗しうる。更新は `set M[K] = V` |
| option | `?item`、`option{v}` / `false` | `Value?` で取り出す (失敗しうる) |
| tuple | `tuple(int, string)` | `(1, "a")` |

### 代数的データ型がない

`Num | Add | Mul` のような和型はない。再帰的なデータは基底クラス + サブクラスで表し、`match` の代わりに仮想メソッド (`Eval<override>`) を使う。

### for は式

`for (I : Items, Cond) { Expr }` は「条件を満たす要素に Expr を適用した配列」を返す。map と filter が 1 つの構文になっている。
条件部分が失敗した要素はスキップされる (失敗コンテキストの応用)。

### 添字・map アクセスは失敗しうる

`Items[0]` や `M[Key]` は範囲外 / 未登録で失敗する。必ず `if (X := Items[0])` の形で使う。null チェックの代わりに失敗コンテキストが働く。

## 他の言語ではこう書く

Rust / OCaml の `enum` + `match` に相当するものは Verse にはなく、C# / Java のように継承で表す。
`for` が配列を返す点は Python の内包表記 `[x for x in xs if cond]` に近い。

## 落とし穴

- `struct` は値型なので、フィールドを変更した新しい値を作るには `item{Old with Qty := 1}` 構文を使う (var で持たない限り変更できない)。
- map の更新 `set M[K] = V` は失敗しうる式なので、`if (set M[K] = V) {}` のように失敗コンテキストで囲む。
- `Print` で struct をそのまま文字列補間はできない。フィールドを個別に出す。
