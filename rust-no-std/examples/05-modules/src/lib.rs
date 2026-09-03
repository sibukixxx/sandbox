//! no_std クレートのモジュール構成。
//!
//! - `mod` でモジュールを宣言し、ファイル/ディレクトリと対応させる
//! - `pub` / `pub(crate)` で可視性を制御する
//! - `use` で名前を取り込む
//! - feature フラグで `alloc` / `std` を段階的に有効化する

#![cfg_attr(not(any(test, feature = "std")), no_std)]

// feature = "alloc" のときだけ alloc クレート (Vec, String など) を使えるようにする
#[cfg(feature = "alloc")]
extern crate alloc;

// ファイルモジュール: src/geometry/mod.rs (またはsrc/geometry.rs) を読み込む
pub mod geometry;

// インラインモジュール: 同じファイル内に書く
pub mod units {
    /// メートル。newtype で単位を型にする
    #[derive(Debug, Clone, Copy, PartialEq)]
    pub struct Meters(pub f32);

    impl Meters {
        pub fn to_cm(self) -> f32 {
            self.0 * 100.0
        }
    }
}

// 深い階層の名前を、クレートのトップレベルから使えるように再エクスポートする
pub use geometry::shapes::{Circle, Rect};
pub use geometry::Shape;

/// 複数の図形の面積の合計。Vec が必要なので alloc feature 限定
#[cfg(feature = "alloc")]
pub fn total_area(shapes: &alloc::vec::Vec<&dyn Shape>) -> f32 {
    shapes.iter().map(|s| s.area()).sum()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn reexport_works() {
        let r = Rect { w: 2.0, h: 3.0 };
        assert_eq!(r.area(), 6.0);
        assert_eq!(units::Meters(1.5).to_cm(), 150.0);
    }

    #[test]
    fn nested_path_works() {
        let c = geometry::shapes::Circle { r: 1.0 };
        assert!((c.area() - core::f32::consts::PI).abs() < 1e-6);
    }

    #[test]
    #[cfg(feature = "alloc")]
    fn total_area_works() {
        let c = Circle { r: 1.0 };
        let r = Rect { w: 1.0, h: 2.0 };
        let v: alloc::vec::Vec<&dyn Shape> = alloc::vec![&c, &r];
        assert!((total_area(&v) - (core::f32::consts::PI + 2.0)).abs() < 1e-6);
    }
}
