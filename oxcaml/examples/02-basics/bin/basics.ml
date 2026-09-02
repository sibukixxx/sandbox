(* 条件分岐を「関数」として書く。
   OCaml では if も match も式なので、関数の本体にそのまま置ける。 *)

(* if-then-else 式。各分岐が同じ型 (string) を返す *)
let sign x =
  if x > 0 then "positive"
  else if x < 0 then "negative"
  else "zero"

(* match 式 + ガード (when)。上から順に最初に一致した腕が選ばれる *)
let classify = function
  | 0 -> "zero"
  | n when n < 0 -> "negative"
  | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 -> "small"
  | _ -> "large"

(* 複数条件をタプルにまとめて match する。網羅性はコンパイラが検査する *)
let fizzbuzz n =
  match n mod 3, n mod 5 with
  | 0, 0 -> "FizzBuzz"
  | 0, _ -> "Fizz"
  | _, 0 -> "Buzz"
  | _ -> string_of_int n

(* バリアント型と match *)
type shape = Circle of int | Square of int | Point

let area = function
  | Circle r -> 3 * r * r
  | Square a -> a * a
  | Point -> 0

(* option 型で「値がない」を分岐として表す *)
let checked_div a b = if b = 0 then None else Some (a / b)

(* Option.bind / let* で option を連鎖させる *)
let average_of_two a b divisor =
  let ( let* ) = Option.bind in
  let* x = checked_div a divisor in
  let* y = checked_div b divisor in
  Some ((x + y) / 2)

(* ---- OxCaml 固有: モードを使った条件分岐 ----
   `local_` を付けると、この関数が返す値はヒープではなくスタックに置かれる。
   条件分岐の各腕がローカルなタプルを返しても、呼び出し側でエスケープしなければアロケーションが起きない。
   標準 OCaml ではコメントアウトして読む。

let choose_pair ~flag = exclave_
  if flag then (1, 2) else (3, 4)

   `[@zero_alloc]` を付けると、この関数がヒープ割り当てを一切しないことをコンパイラが検査する。

let[@zero_alloc] sign_code x = if x > 0 then 1 else if x < 0 then -1 else 0
*)
