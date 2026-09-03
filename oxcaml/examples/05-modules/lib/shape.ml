(* ファイル = モジュール。lib/shape.ml は Geometry.Shape として見える
   (dune が library 名 geometry でラップするため)。 *)

(* シグネチャ (インターフェース) をモジュール型として定義する *)
module type S = sig
  type t
  val area : t -> float
  val name : string
end

(* モジュール内だけで使うヘルパー。.mli を書けば外に出さないこともできる *)
let square x = x *. x

let circle_area r = Float.pi *. square r
