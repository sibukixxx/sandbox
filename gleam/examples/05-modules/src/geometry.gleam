//// モジュール geometry。geometry/shape とは別のモジュール (親子関係はない)。
//// 集計関数をここに置き、shape を import して使う。

import geometry/shape.{type Shape}
import gleam/float
import gleam/list

pub fn total_area(shapes: List(Shape)) -> Float {
  shapes
  |> list.map(shape.area)
  |> list.fold(0.0, float.add)
}
