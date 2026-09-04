//! モジュール "geometry" のルート。子ファイルを @import して公開する。
//! ファイルは struct。`pub` を付けた宣言だけが外から見える。

pub const shapes = @import("shapes.zig");
pub const Shape = shapes.Shape;
pub const Circle = shapes.Circle;
pub const Rect = shapes.Rect;

/// モジュール内で共有するヘルパー。pub なので shapes.zig からも @import("root.zig") 経由で使える
pub fn square(x: f32) f32 {
    return x * x;
}

// テストは各ファイルに書ける。ルートから参照されるファイルのテストも `zig build test` で走る
test {
    @import("std").testing.refAllDecls(@This());
}
