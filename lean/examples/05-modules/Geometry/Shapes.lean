import Geometry.Basic

namespace Geometry

structure Circle where
  r : Float

structure Rect where
  w : Float
  h : Float

/-- 型クラスのインスタンス。`Geometry.Shape` は同じ namespace 内なので `Shape` で参照できる。 -/
instance : Shape Circle where
  area c := circleArea c.r

instance : Shape Rect where
  area r := r.w * r.h

/-- `Circle.describe` と定義すると `c.describe` (ドット記法) で呼べる。 -/
def Circle.describe (c : Circle) : String :=
  s!"circle r={c.r} area={Shape.area c}"

end Geometry

-- namespace の外。別 namespace に置くこともできる。 (`/-- -/` は宣言専用なので namespace には付けられない)
namespace Units

structure Meters where
  val : Float

def Meters.toCm (m : Meters) : Float := m.val * 100.0

end Units
