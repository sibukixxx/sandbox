(* データ構造とパターンマッチ。題材: 在庫 (item) と数式 (expr) の評価器。 *)

(* バリアント (ペイロードなし) *)
type category = Food | Tool

(* レコード *)
type item = { name : string; price : int; qty : int; category : category }

(* 再帰的なバリアント。GC があるので Box なしでそのまま再帰できる *)
type expr = Num of int | Add of expr * expr | Mul of expr * expr

(* 再帰的なパターンマッチで評価する *)
let rec eval = function
  | Num n -> n
  | Add (a, b) -> eval a + eval b
  | Mul (a, b) -> eval a * eval b

(* List の map / filter / fold_left *)
let total_value items =
  items |> List.map (fun i -> i.price * i.qty) |> List.fold_left ( + ) 0

let in_stock items = List.filter (fun i -> i.qty > 0) items

(* option を返す検索 *)
let find items name = List.find_opt (fun i -> i.name = name) items

(* リストのパターンマッチ: 先頭要素と残り *)
let first_name = function [] -> None | head :: _ -> Some head.name

(* Map モジュールはファンクタで作る。キーの型ごとに専用の Map を生成する *)
module CatMap = Map.Make (struct
  type t = category
  let compare = compare
end)

let value_by_category items =
  List.fold_left
    (fun m i ->
      let v = i.price * i.qty in
      CatMap.update i.category
        (function None -> Some v | Some cur -> Some (cur + v))
        m)
    CatMap.empty items

(* 配列 (可変・固定長) とタプル *)
let price_range items =
  let arr = Array.of_list (List.map (fun i -> i.price) items) in
  Array.sort compare arr;
  (arr.(0), arr.(Array.length arr - 1))

let sample =
  [
    { name = "apple"; price = 100; qty = 3; category = Food };
    { name = "hammer"; price = 1500; qty = 0; category = Tool };
    { name = "bread"; price = 200; qty = 2; category = Food };
  ]

(* ---- OxCaml 固有: unboxed 型とレコード ----
   `float#` は unboxed な float。レコードのフィールドに使うと、
   1 レコード = 1 アロケーション (フィールドごとのボックス化がない) になる。
   標準 OCaml ではコンパイルできないのでコメント内。

type point = { x : float#; y : float# }
let norm2 (p : point) = Float_u.(p.x * p.x + p.y * p.y)

   `#(int * int)` は unboxed タプル。関数から複数の値を返してもアロケーションが起きない。

let min_max (a : int) (b : int) : #(int * int) = if a < b then #(a, b) else #(b, a)
*)
