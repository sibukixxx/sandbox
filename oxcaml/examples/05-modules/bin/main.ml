(* ライブラリ geometry のモジュールは Geometry.Shapes のようにアクセスする *)
open Geometry

let () =
  let open Shapes in
  let shapes = [ Packed ((module Circle), 1.0); Packed ((module Rect), (1.0, 2.0)) ] in
  Printf.printf "circle: %g\n" (Circle.area 1.0);
  Printf.printf "rect:   %g\n" (Rect.area (1.0, 2.0));
  Printf.printf "total:  %g\n" (total_area shapes);
  (* ローカル open: この式の中だけ Units の名前が見える *)
  print_endline Units.(Cm.show (Cm.of_meters 1.5));
  print_endline Units.(Mm.show (Mm.of_meters 1.5))
