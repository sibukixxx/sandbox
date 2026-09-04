//! comptime: コンパイル時に Zig のコードを実行する。
//! ジェネリクス、テーブル生成、型の検査、型安全な printf がすべて comptime で実現される。
//! Zig を学ぶ最大の理由。

const std = @import("std");

// ---- 1. comptime 引数 = ジェネリクス ----
// 型 (`type`) は comptime の値として渡せる。関数が型を返せば「ジェネリック型」になる
fn Stack(comptime T: type, comptime capacity: usize) type {
    return struct {
        items: [capacity]T = undefined,
        len: usize = 0,

        const Self = @This();

        pub fn push(self: *Self, v: T) !void {
            if (self.len == capacity) return error.Full;
            self.items[self.len] = v;
            self.len += 1;
        }

        pub fn pop(self: *Self) ?T {
            if (self.len == 0) return null;
            self.len -= 1;
            return self.items[self.len];
        }
    };
}

// ---- 2. comptime でテーブルを生成する ----
// ループも関数呼び出しもコンパイル時に走り、結果はバイナリに定数として埋め込まれる
fn makeSquares(comptime n: usize) [n]u32 {
    var t: [n]u32 = undefined;
    for (&t, 0..) |*v, i| v.* = @intCast(i * i);
    return t;
}
const squares = makeSquares(10); // コンパイル時に計算済み

// ---- 3. 型情報で分岐する (@typeInfo) ----
// 「整数なら」「スライスなら」をコンパイル時に判定し、型ごとに違うコードを生成する
fn describe(comptime T: type) []const u8 {
    return switch (@typeInfo(T)) {
        .int => |info| if (info.signedness == .signed) "signed int" else "unsigned int",
        .float => "float",
        .pointer => |p| if (p.size == .slice) "slice" else "pointer",
        .@"struct" => "struct",
        .optional => "optional",
        else => "other",
    };
}

// ---- 4. 型安全な汎用関数 ----
// anytype で受け取り、comptime に型を検査する。合わなければコンパイルエラー
fn sum(xs: anytype) @TypeOf(xs[0]) {
    const T = @TypeOf(xs[0]);
    comptime if (@typeInfo(T) != .int and @typeInfo(T) != .float)
        @compileError("sum requires numbers, got " ++ @typeName(T));
    var acc: T = 0;
    for (xs) |x| acc += x;
    return acc;
}

// ---- 5. comptime で構造体のフィールドを走査する ----
// リフレクションのように使えるが、実行時コストはゼロ
fn fieldNames(comptime T: type) [std.meta.fields(T).len][]const u8 {
    var names: [std.meta.fields(T).len][]const u8 = undefined;
    inline for (std.meta.fields(T), 0..) |f, i| names[i] = f.name;
    return names;
}

const Point = struct { x: f32, y: f32, label: []const u8 };

// ---- 6. inline for / comptime var ----
fn countBits(comptime n: u32) u32 {
    comptime var count: u32 = 0;
    comptime var v = n;
    inline while (v != 0) : (v >>= 1) count += v & 1;
    return count;
}

pub fn main(init: std.process.Init) !void {
    var buffer: [1024]u8 = undefined;
    var w = std.Io.File.stdout().writer(init.io, &buffer);
    const out = &w.interface;

    var s = Stack(i32, 4){};
    try s.push(10);
    try s.push(20);
    try out.print("pop: {?d} {?d} {?d}\n", .{ s.pop(), s.pop(), s.pop() });

    try out.print("squares: {any}\n", .{squares});
    try out.print("i32: {s}, u8: {s}, []u8: {s}, ?f32: {s}\n", .{ describe(i32), describe(u8), describe([]u8), describe(?f32) });
    try out.print("sum: {d} {d:.1}\n", .{ sum([_]i32{ 1, 2, 3 }), sum([_]f32{ 1.5, 2.5 }) });
    // sum([_][]const u8{"a"}) はコンパイルエラー: sum requires numbers, got []const u8
    try out.print("fields: {s} {s} {s}\n", .{ fieldNames(Point)[0], fieldNames(Point)[1], fieldNames(Point)[2] });
    try out.print("bits(0b1011): {d}\n", .{countBits(0b1011)});
    try out.flush();
}

test "generic stack" {
    var s = Stack(u8, 2){};
    try s.push(1);
    try s.push(2);
    try std.testing.expectError(error.Full, s.push(3));
    try std.testing.expectEqual(@as(?u8, 2), s.pop());
}

test "comptime table and typeinfo" {
    try std.testing.expectEqual(81, squares[9]);
    try std.testing.expectEqualStrings("signed int", describe(i64));
    try std.testing.expectEqual(3, countBits(0b1011));
    try std.testing.expectEqualStrings("label", fieldNames(Point)[2]);
}
