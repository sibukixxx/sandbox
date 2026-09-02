# 03. 条件分岐を関数として書く

対応サンプル: [`examples/02-basics/`](../examples/02-basics/)

## 目的

OCaml の `if` / `match` が式であることを使い、条件分岐を「値を返す関数」として書く。OxCaml のモードが分岐にどう関わるかも見る。

## 最小コード

```ocaml
let sign x =
  if x > 0 then "positive"
  else if x < 0 then "negative"
  else "zero"

let classify = function
  | 0 -> "zero"
  | n when n < 0 -> "negative"
  | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 -> "small"
  | _ -> "large"

let fizzbuzz n =
  match n mod 3, n mod 5 with
  | 0, 0 -> "FizzBuzz"
  | 0, _ -> "Fizz"
  | _, 0 -> "Buzz"
  | _ -> string_of_int n
```

## 解説

- **`if ... then ... else`** は式。`else` を省略すると then 側は `unit` でなければならない。
- **`function`** は「引数を 1 つ取ってすぐ `match` する関数」の省略形。`let classify x = match x with ...` と同じ。
- **`when` ガード**、**or パターン** `1 | 2 | 3`、**タプル** `n mod 3, n mod 5` (括弧なしでタプルになる)。網羅性はコンパイラが警告する。
- **バリアント型** `type shape = Circle of int | Square of int | Point` と `match`。
- **`option`** と `let*` (`Option.bind`) で「値がない」を分岐として連鎖させる。
- 型注釈は不要。`sign : int -> string` は推論される。

### OxCaml 固有: 分岐とモード

```ocaml
(* 分岐の結果をスタックに置く。呼び出し側でエスケープしなければヒープ割り当てなし *)
let choose_pair ~flag = exclave_
  if flag then (1, 2) else (3, 4)

(* この関数がヒープ割り当てをしないことをコンパイラに検査させる *)
let[@zero_alloc] sign_code x = if x > 0 then 1 else if x < 0 then -1 else 0
```

- `exclave_` / `local_`: 値をスタック (呼び出し元のリージョン) に置く。分岐の各腕が返すタプルもスタックに置ける。
- `[@zero_alloc]`: 割り当てが起きる分岐があればコンパイルエラーになる。性能が重要なコードで「意図せず割り当てが入る」ことを防ぐ。

サンプルではこれらをコメント内に置いてあり、OxCaml switch でコメントを外すと動く。

## 他の言語ではこう書く

Rust の `match` とほぼ同じ。Rust では `&'static str` を返すが、OCaml の文字列リテラルは単に `string`。
`[@zero_alloc]` に相当するものは Rust にはなく、`no_std` で「そもそもヒープがない」ことで代用する。

## 落とし穴

- `if a then b; c` は `(if a then b); c` と解釈される。分岐内で複数文を書くときは `begin ... end` か括弧で囲む。
- `match` の腕は上から順に評価され、`when` ガードがあると網羅性検査が弱くなる。
- 整数の比較 `=` と物理的等価 `==` を混同しない。通常は `=`。
