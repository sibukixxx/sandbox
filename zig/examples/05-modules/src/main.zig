const std = @import("std");
const geometry = @import("geometry"); // build.zig で登録した名前付きモジュール
const units = @import("units.zig"); // 相対パスのファイルモジュール

pub fn main(init: std.process.Init) !void {
    var buffer: [256]u8 = undefined;
    var w = std.Io.File.stdout().writer(init.io, &buffer);
    const out = &w.interface;

    const c = geometry.Circle{ .r = 1 };
    const r = geometry.Rect{ .w = 1, .h = 2 };
    try out.print("circle: {d:.4}\n", .{c.area()});
    try out.print("rect:   {d:.4}\n", .{r.area()});
    const shapes = [_]geometry.Shape{ .{ .circle = c }, .{ .rect = r } };
    try out.print("total:  {d:.4}\n", .{geometry.shapes.totalArea(&shapes)});
    try out.print("1.5m = {d}cm\n", .{(units.Meters{ .val = 1.5 }).toCm()});
    try out.flush();
}
