(* OxCaml 固有機能: モード (local / unique / once) と unboxed 型。
   このファイルは OxCaml switch (5.2.0+ox) でのみコンパイルできる。標準 OCaml では動かない。

   このリポジトリでは OxCaml のビルドを確認できていない (docs/05-core.md 参照)。
   構文は https://oxcaml.org/documentation/ に基づく。 *)

(* ---- 1. local_: スタック割り当て ----
   `local_` を付けた値は、その関数のリージョン (スタックフレーム) に置かれ、
   関数から抜けるときに解放される。GC の対象にならない。
   ローカルな値を関数の外に持ち出そうとするとコンパイルエラーになる。 *)

let sum_pair (p : int * int) = fst p + snd p

let use_local () =
  let local_ p = (1, 2) in   (* このタプルはヒープではなくスタックに置かれる *)
  sum_pair p                 (* sum_pair は p をエスケープさせないので渡せる *)
  (* let escape () = p in ... はエラー: local value escapes its region *)

(* exclave_: 呼び出し元のリージョンに値を置いて返す。
   「ローカルな値を返す関数」を書くときに使う。 *)
let make_pair a b = exclave_ (a, b)

(* 引数にも local_ を付けられる。「この関数は引数を保持しない」という約束になり、
   呼び出し側はローカルな値を渡せる。 *)
let print_pair (local_ p : int * int) = Printf.printf "(%d, %d)\n" (fst p) (snd p)

(* ---- 2. [@zero_alloc]: 割り当てなしをコンパイラに検査させる ----
   この属性を付けた関数がヒープ割り当てを行うと、コンパイルエラーになる。
   ホットパスで「うっかり割り当てが入る」ことを防ぐ。 *)

let[@zero_alloc] clamp lo hi x = if x < lo then lo else if x > hi then hi else x

(* タプルを返すと通常は割り当てが起きるが、exclave_ でローカルに返せば割り当てなし *)
let[@zero_alloc] min_max a b = exclave_ if a < b then (a, b) else (b, a)

(* ---- 3. unique_: 一意な所有 ----
   `unique_` な値は「この参照が唯一」であることを型が保証する。
   一意なら、安全に in-place で更新 (再利用) できる。使った後の値を再度使うとエラー。 *)

let overwrite (unique_ r : int ref) = r := 0; r
(* let r1 = ref 5 in let r2 = overwrite r1 in !r1  はエラー: r1 は既に消費されている *)

(* ---- 4. unboxed 型 ----
   float# は unboxed な float (ヒープを経由しない 64bit 値)。
   標準 OCaml の float はボックス化されるので、レコードのフィールドや関数の返り値で割り当てが起きる。 *)

type vec2 = { x : float#; y : float# }   (* 1 レコード = 1 割り当て。フィールドごとの割り当てはない *)

let dot (a : vec2) (b : vec2) : float# = Float_u.(a.x * b.x + a.y * b.y)

(* #(int * int) は unboxed タプル。複数の値を返してもヒープを使わない *)
let divmod a b : #(int * int) = #(a / b, a mod b)

(* ---- 5. 標準 OCaml との互換 ----
   モードや unboxed 型を使わないコードはそのまま動く。
   ライブラリの「ホットパスだけ」にモードを付ける、という段階的な導入ができる。 *)

let () =
  Printf.printf "use_local = %d\n" (use_local ());
  print_pair (make_pair 3 4);
  Printf.printf "clamp = %d\n" (clamp 0 10 42);
  let lo, hi = min_max 9 2 in
  Printf.printf "min_max = (%d, %d)\n" lo hi;
  let v = { x = #1.0; y = #2.0 } in
  Printf.printf "dot = %f\n" (Float_u.to_float (dot v v));
  let #(q, r) = divmod 17 5 in
  Printf.printf "divmod = (%d, %d)\n" q r;
  let r = overwrite (ref 5) in
  Printf.printf "overwrite = %d\n" !r
