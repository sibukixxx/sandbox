//! geometry モジュールのルート。子モジュールを宣言し、共通の trait を定義する。

pub mod shapes;

/// 面積を持つもの。core だけで定義できる
pub trait Shape {
    fn area(&self) -> f32;
}

/// クレート内でのみ使えるヘルパー。外部クレートからは見えない
pub(crate) fn square(x: f32) -> f32 {
    x * x
}
