(* 同じライブラリ内の別ファイルは Shape のように直接参照できる *)

module Circle : Shape.S with type t = float = struct
  type t = float
  let area r = Shape.circle_area r
  let name = "circle"
end

module Rect : Shape.S with type t = float * float = struct
  type t = float * float
  let area (w, h) = w *. h
  let name = "rect"
end

(* ファーストクラスモジュール: モジュールを値として扱う *)
type packed = Packed : (module Shape.S with type t = 'a) * 'a -> packed

let area_of (Packed ((module M), v)) = M.area v

let total_area shapes = List.fold_left (fun acc s -> acc +. area_of s) 0.0 shapes
