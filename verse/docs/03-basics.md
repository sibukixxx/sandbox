# 03. 条件分岐を関数として書く

対応サンプル: [`examples/02-basics/`](../examples/02-basics/)

## 目的

Verse の `if` が式であること、そして条件が「失敗しうる式」であることを理解する。

## 最小コード

```verse
Sign(X:int):string =
    if (X > 0) then "positive"
    else if (X < 0) then "negative"
    else "zero"
```

## 解説

### if は式

1 行形式 `if (c) then a else b` も、ブロック形式も値を返す。ブロックでは最後の式が値になる。

```verse
Classify(X:int):string =
    if (X = 0):
        "zero"
    else if (X < 0):
        "negative"
    else:
        "large"
```

比較の等号は `=` (代入ではない)。不等号は `<>`。

### 条件は「失敗しうる式」

Verse には bool を返す比較演算子がない。`X > 0` は「成功したら X を返し、失敗する」式である。
`if` は「条件が成功したら then」と読む。この仕組みを **失敗コンテキスト** と呼ぶ。

自分で失敗しうる関数を書くには `<decides>` を付け、`Func[Args]` (角括弧) で呼ぶ。

```verse
IsPositive(X:int)<decides><transacts>:void =
    X > 0

if (IsPositive[5]):
    Print("positive")
```

`<decides>` 関数が値を返せば、成功時だけ値が得られる。Option の代わりに使える。

```verse
CheckedDiv(A:int, B:int)<decides><transacts>:int =
    B <> 0
    A / B

if (Q := CheckedDiv[10, 2]):
    Print("{Q}")
```

### option 型

「値があるかもしれない」を型で表すには `?int`。`option{v}` で包み、`false` が空。
取り出しは `Value?` で、これも失敗しうる式なので `if` の条件に置く。

### for による絞り込み

`for (X := Xs, Cond[X]) { X }` は、条件が失敗した要素をスキップする。他言語の filter に相当する。

## 他の言語ではこう書く

| | Verse | Rust |
|---|---|---|
| 条件 | 失敗しうる式 | `bool` |
| 失敗しうる関数 | `<decides>` + `F[x]` | `Option<T>` を返す |
| 値の取り出し | `if (V := Opt?)` | `if let Some(v) = opt` |

## 落とし穴

- `=` は比較。代入は `set X = ...`、定義は `:=`。
- `<decides>` は通常 `<transacts>` と組で使う (失敗時に副作用をロールバックするため)。
- `Mod[N, 3]` のように、標準関数にも失敗しうるものがある (角括弧で呼ぶ)。
