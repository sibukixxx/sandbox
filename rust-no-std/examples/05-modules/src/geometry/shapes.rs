//! 具体的な図形。親モジュールの trait とヘルパーを `super::` で参照する。

use super::{square, Shape};

#[derive(Debug, Clone, Copy, PartialEq)]
pub struct Circle {
    pub r: f32,
}

#[derive(Debug, Clone, Copy, PartialEq)]
pub struct Rect {
    pub w: f32,
    pub h: f32,
}

impl Shape for Circle {
    fn area(&self) -> f32 {
        core::f32::consts::PI * square(self.r)
    }
}

impl Shape for Rect {
    fn area(&self) -> f32 {
        self.w * self.h
    }
}
