/-! `namespace` は名前の接頭辞。ファイルモジュールとは独立している。 -/

namespace Geometry

/-- 面積を持つもの。型クラスで表す。 -/
class Shape (α : Type) where
  area : α → Float

/-- `private` はこのファイル内でしか見えない。 -/
private def square (x : Float) : Float := x * x

def circleArea (r : Float) : Float := 3.141592653589793 * square r

end Geometry
