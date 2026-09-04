// モジュールの取り込み。
//   import geometry/shape          → shape/area のように修飾なしでも使える (曖昧なら修飾する)
//   import units                   → units/to-cm など
// ファイルは `koka -i. -e main.kk` のように include パス (-i) から探される
import geometry/shape
import units
import std/num/float64   // float64 の show のため

fun main()
  val c = Circle(1.0)
  val r = Rect(1.0, 2.0)
  println("circle: " ++ c.area.show)
  println("rect:   " ++ r.area.show)
  println("total:  " ++ total-area([c, r]).show)
  val m = Meters(1.5)
  // units/show と std の show が曖昧になるときは、モジュール名で修飾する
  println(units/show(m) ++ " = " ++ m.to-cm.show ++ "cm")
