// モジュールの取り込み。
//   import geometry/shape                → shape.area のように最後の要素で参照
//   import geometry/shape.{Circle, Rect} → 名前を直接使う (unqualified import)
//   import units as u                    → 別名

import geometry
import geometry/shape.{Circle, Rect}
import gleam/float
import gleam/io
import units as u

pub fn main() -> Nil {
  let c = Circle(1.0)
  let r = Rect(1.0, 2.0)
  io.println("circle: " <> float.to_string(shape.area(c)))
  io.println("rect:   " <> float.to_string(shape.area(r)))
  io.println("total:  " <> float.to_string(geometry.total_area([c, r])))
  case u.meters(1.5) {
    Ok(m) -> io.println("1.5m = " <> float.to_string(u.to_cm(m)) <> "cm")
    Error(e) -> io.println(e)
  }
  // u.Meters(-1.0) は書けない (opaque)。meters(-1.0) は Error を返す
  case u.meters(-1.0) {
    Ok(_) -> io.println("unexpected")
    Error(e) -> io.println("error: " <> e)
  }
}
