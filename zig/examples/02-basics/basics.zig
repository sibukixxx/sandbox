//! 条件分岐を「関数」として書く。Zig の if / switch は式。

const std = @import("std");

/// if-else 式。各分岐が同じ型 ([]const u8) を返す
fn sign(x: i32) []const u8 {
    return if (x > 0) "positive" else if (x < 0) "negative" else "zero";
}

/// switch 式。範囲 (`1...9`)、複数値 (`0, 10`)、else が使える。網羅性はコンパイラが検査
fn classify(x: i32) []const u8 {
    return switch (x) {
        0 => "zero",
        1...9 => "small",
        else => if (x < 0) "negative" else "large",
    };
}

/// タプル相当: switch は 1 値しか取れないので、条件を bool の組で表す
fn fizzbuzz(n: u32) []const u8 {
    const by3 = n % 3 == 0;
    const by5 = n % 5 == 0;
    if (by3 and by5) return "FizzBuzz";
    if (by3) return "Fizz";
    if (by5) return "Buzz";
    return "number";
}

/// Optional 型 `?i32`。null が「値なし」
fn checkedDiv(a: i32, b: i32) ?i32 {
    return if (b == 0) null else @divTrunc(a, b);
}

/// `orelse` で null のときの値、`if (opt) |v|` で中身を取り出す
fn averageOfTwo(a: i32, b: i32, divisor: i32) ?i32 {
    const x = checkedDiv(a, divisor) orelse return null;
    const y = checkedDiv(b, divisor) orelse return null;
    return @divTrunc(x + y, 2);
}

/// エラー共用体 `!i32`。Optional と違い「なぜ失敗したか」を持てる
const DivError = error{DivisionByZero};

fn safeDiv(a: i32, b: i32) DivError!i32 {
    if (b == 0) return error.DivisionByZero;
    return @divTrunc(a, b);
}

/// comptime: 引数が定数なら、この if はコンパイル時に評価される
fn abs(x: i32) i32 {
    return if (x < 0) -x else x;
}
const ABS_MIN = abs(-7); // コンパイル時定数

pub fn main(init: std.process.Init) !void {
    var buffer: [512]u8 = undefined;
    var w = std.Io.File.stdout().writer(init.io, &buffer);
    const out = &w.interface;
    var n: u32 = 1;
    while (n <= 15) : (n += 1) {
        try out.print("{d}: {s} / {s}\n", .{ n, fizzbuzz(n), classify(@intCast(n)) });
    }
    try out.print("{?d} {?d} {d}\n", .{ averageOfTwo(6, 4, 2), averageOfTwo(6, 4, 0), ABS_MIN });
    // catch でエラーを処理する
    const q = safeDiv(1, 0) catch |err| blk: {
        try out.print("error: {s}\n", .{@errorName(err)});
        break :blk 0;
    };
    try out.print("q = {d}\n", .{q});
    try out.flush();
}

// テストはソースに書き、`zig test basics.zig` で実行する
test "sign" {
    try std.testing.expectEqualStrings("positive", sign(3));
    try std.testing.expectEqualStrings("negative", sign(-3));
    try std.testing.expectEqualStrings("zero", sign(0));
}

test "classify and fizzbuzz" {
    try std.testing.expectEqualStrings("small", classify(5));
    try std.testing.expectEqualStrings("large", classify(50));
    try std.testing.expectEqualStrings("FizzBuzz", fizzbuzz(15));
    try std.testing.expectEqualStrings("number", fizzbuzz(7));
}

test "optional and error" {
    try std.testing.expectEqual(@as(?i32, 2), averageOfTwo(6, 4, 2));
    try std.testing.expectEqual(@as(?i32, null), averageOfTwo(6, 4, 0));
    try std.testing.expectError(error.DivisionByZero, safeDiv(1, 0));
    try std.testing.expectEqual(7, ABS_MIN);
}
