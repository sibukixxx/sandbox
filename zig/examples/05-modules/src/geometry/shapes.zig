//! 具体的な図形。同じモジュール内の別ファイルは相対パスで @import する。
const std = @import("std");
const root = @import("root.zig");

pub const Circle = struct {
    r: f32,
    pub fn area(self: Circle) f32 {
        return std.math.pi * root.square(self.r);
    }
};

pub const Rect = struct {
    w: f32,
    h: f32,
    pub fn area(self: Rect) f32 {
        return self.w * self.h;
    }
};

/// 「インターフェース」は tagged union か、vtable を持つ struct で表す。ここでは tagged union
pub const Shape = union(enum) {
    circle: Circle,
    rect: Rect,

    pub fn area(self: Shape) f32 {
        return switch (self) {
            inline else => |s| s.area(), // inline else: 各バリアントに同名メソッドがあれば一括で呼べる
        };
    }
};

pub fn totalArea(shapes: []const Shape) f32 {
    var sum: f32 = 0;
    for (shapes) |s| sum += s.area();
    return sum;
}

test "shapes" {
    const r = Rect{ .w = 2, .h = 3 };
    try std.testing.expectEqual(6, r.area());
    const shapes = [_]Shape{ .{ .circle = .{ .r = 1 } }, .{ .rect = r } };
    try std.testing.expectApproxEqAbs(std.math.pi + 6, totalArea(&shapes), 1e-5);
}
