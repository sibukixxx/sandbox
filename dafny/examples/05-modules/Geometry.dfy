// 別ファイルのモジュール。`include "Geometry.dfy"` で読み込む。
module Geometry {
  datatype Shape = Circle(r: int) | Rect(w: int, h: int)

  // module 内の名前は既定で公開。`export` を書くと公開範囲を制御できる (下の Units 参照)
  function Area(s: Shape): int
    ensures Area(s) >= 0 || s.Circle? || s.Rect?
  {
    match s
    case Circle(r) => 3 * r * r
    case Rect(w, h) => w * h
  }

  function TotalArea(shapes: seq<Shape>): int
  {
    if |shapes| == 0 then 0
    else Area(shapes[0]) + TotalArea(shapes[1..])
  }
}
