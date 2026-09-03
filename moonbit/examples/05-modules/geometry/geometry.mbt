///|
/// 面積を持つもの。`pub(open)` にすると他パッケージでも impl できる。
pub(open) trait Shape {
  area(Self) -> Double
}

///|
/// `pub` を付けないと、このパッケージ内でしか見えない。
fn square(x : Double) -> Double {
  x * x
}

///|
/// パッケージ内の非公開関数を使う公開関数。
pub fn circle_area(r : Double) -> Double {
  3.141592653589793 * square(r)
}
