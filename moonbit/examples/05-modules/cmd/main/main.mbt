///|
/// trait オブジェクト (`&@geometry.Shape`) で異なる型を同じ配列に入れる。
fn total_area(shapes : Array[&@geometry.Shape]) -> Double {
  shapes.fold(init=0.0, (acc, s) => acc + s.area())
}

///|
fn main {
  let c = @shapes.Circle::{ r: 1.0 }
  let r = @shapes.Rect::{ w: 1.0, h: 2.0 }
  println("circle: \{c.area()}")
  println("rect:   \{r.area()}")
  println("total:  \{total_area([c, r])}")
  println("1.5m = \{@units.Meters(1.5).to_cm()}cm")
}
