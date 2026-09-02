import Geometry

-- `open` で namespace の接頭辞を省略できる。ファイル全体に効く。
open Geometry in
def totalArea (c : Circle) (r : Rect) : Float :=
  Shape.area c + Shape.area r

def main : IO Unit := do
  let c : Geometry.Circle := { r := 1.0 }
  let r : Geometry.Rect := { w := 1.0, h := 2.0 }
  IO.println c.describe
  IO.println s!"rect:  {Geometry.Shape.area r}"
  IO.println s!"total: {totalArea c r}"
  -- `open ... in` は 1 つの宣言だけに効く。ここでは明示的に書く。
  let m : Units.Meters := { val := 1.5 }
  IO.println s!"1.5m = {m.toCm}cm"
