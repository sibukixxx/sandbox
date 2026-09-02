///|
/// `pub(all)` にすると他パッケージから構築 (`Circle::{ r: 1.0 }`) もできる。
/// `pub` だけだと型は見えるがフィールドは読み取り専用になる。
pub(all) struct Circle {
  r : Double
}

///|
pub(all) struct Rect {
  w : Double
  h : Double
}

///|
/// 他パッケージの trait を実装する。`@geometry` は import した名前 (既定はディレクトリ名末尾)。
pub impl @geometry.Shape for Circle with area(self) {
  @geometry.circle_area(self.r)
}

///|
pub impl @geometry.Shape for Rect with area(self) {
  self.w * self.h
}

///|
test "shapes" {
  assert_eq(Rect::{ w: 2.0, h: 3.0 }.area(), 6.0)
}
