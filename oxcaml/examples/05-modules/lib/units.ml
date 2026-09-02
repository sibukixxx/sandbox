(* ファンクタ: モジュールを受け取ってモジュールを返す *)
module type Unit = sig
  val name : string
  val factor : float
end

module Make (U : Unit) = struct
  type t = float
  let of_meters m = m *. U.factor
  let show x = Printf.sprintf "%g%s" x U.name
end

module Cm = Make (struct let name = "cm" let factor = 100.0 end)
module Mm = Make (struct let name = "mm" let factor = 1000.0 end)
