//// モジュール geometry/shape。ファイルパス = モジュール名。
//// `pub` を付けたものだけが外から見える。

/// カスタム型。コンストラクタも pub で公開される
pub type Shape {
  Circle(r: Float)
  Rect(w: Float, h: Float)
}

/// 非公開ヘルパー
fn square(x: Float) -> Float {
  x *. x
}

pub fn area(s: Shape) -> Float {
  case s {
    Circle(r) -> 3.141592653589793 *. square(r)
    Rect(w, h) -> w *. h
  }
}
