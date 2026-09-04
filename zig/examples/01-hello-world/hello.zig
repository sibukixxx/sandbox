//! Zig の Hello, World (Zig 0.16)。
//! main は `std.process.Init` を受け取れる。`init.io` が I/O の入口 (std.Io インターフェース)。
const std = @import("std");

pub fn main(init: std.process.Init) !void {
    // 最小形: 文字列をそのまま書く
    try std.Io.File.stdout().writeStreamingAll(init.io, "Hello, World!\n");

    // 書式付き出力: バッファ付き Writer を作り、最後に flush する
    var buffer: [256]u8 = undefined;
    var w = std.Io.File.stdout().writer(init.io, &buffer);
    const out = &w.interface;
    try out.print("Hello, {s}! ({d} + {d} = {d})\n", .{ "Zig", 1, 2, 1 + 2 });
    try out.flush(); // 忘れると何も出ない
}
