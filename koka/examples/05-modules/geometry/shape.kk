// モジュール geometry/shape。ファイルパスがモジュール名になる (geometry/shape)。
// 先頭で `module geometry/shape` と宣言する (省略するとファイル名から決まる)。
module geometry/shape

// float64 の演算と show は std/num/float64 にある (int と違い自動では入らない)
import std/num/float64

// pub を付けたものだけが外から見える。既定は非公開
pub type shape
  Circle(r : float64)
  Rect(w : float64, h : float64)

// 非公開のヘルパー
fun square(x : float64) : float64
  x * x

pub fun area(s : shape) : float64
  match s
    Circle(r) -> 3.141592653589793 * square(r)
    Rect(w, h) -> w * h

pub fun total-area(shapes : list<shape>) : float64
  shapes.map(area).foldl(0.0, (+))
