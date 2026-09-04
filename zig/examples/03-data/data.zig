//! データ構造とパターンマッチ。題材: 在庫 (Item) と数式 (Expr) の評価器。
//! Zig にはヒープの暗黙利用がない。動的なものは必ずアロケータを受け取る。

const std = @import("std");

/// enum (ペイロードなし)
const Category = enum { food, tool };

/// struct (レコード)。フィールドに既定値も書ける
const Item = struct {
    name: []const u8,
    price: u32,
    qty: u32 = 0,
    category: Category,
};

/// tagged union = 代数的データ型。再帰は自己参照ポインタで
const Expr = union(enum) {
    num: i64,
    add: [2]*const Expr,
    mul: [2]*const Expr,
};

/// switch で tagged union を分解する。`|v|` でペイロードを受け取る
fn eval(e: *const Expr) i64 {
    return switch (e.*) {
        .num => |n| n,
        .add => |ab| eval(ab[0]) + eval(ab[1]),
        .mul => |ab| eval(ab[0]) * eval(ab[1]),
    };
}

/// スライス `[]const Item` を for で走査。map / filter は「for で書く」のが Zig 流
fn totalValue(items: []const Item) u32 {
    var sum: u32 = 0;
    for (items) |i| sum += i.price * i.qty;
    return sum;
}

fn inStockCount(items: []const Item) usize {
    var n: usize = 0;
    for (items) |i| {
        if (i.qty > 0) n += 1;
    }
    return n;
}

/// Optional を返す検索。`std.mem.eql` で文字列比較
fn find(items: []const Item, name: []const u8) ?Item {
    for (items) |i| {
        if (std.mem.eql(u8, i.name, name)) return i;
    }
    return null;
}

/// スライスの先頭。空なら null
fn firstName(items: []const Item) ?[]const u8 {
    return if (items.len == 0) null else items[0].name;
}

/// enum をインデックスにした固定長配列で集計。std.EnumArray を使うと型安全
fn valueByCategory(items: []const Item) std.EnumArray(Category, u32) {
    var acc = std.EnumArray(Category, u32).initFill(0);
    for (items) |i| acc.getPtr(i.category).* += i.price * i.qty;
    return acc;
}

/// 動的な構造はアロケータを受け取る。ArrayList と StringHashMap
fn namesSorted(alloc: std.mem.Allocator, items: []const Item) ![][]const u8 {
    var list: std.ArrayList([]const u8) = .empty;
    for (items) |i| try list.append(alloc, i.name);
    std.mem.sort([]const u8, list.items, {}, struct {
        fn lt(_: void, a: []const u8, b: []const u8) bool {
            return std.mem.lessThan(u8, a, b);
        }
    }.lt);
    return list.toOwnedSlice(alloc);
}

fn qtyMap(alloc: std.mem.Allocator, items: []const Item) !std.StringHashMap(u32) {
    var m = std.StringHashMap(u32).init(alloc);
    for (items) |i| try m.put(i.name, i.qty);
    return m;
}

const sample = [_]Item{
    .{ .name = "apple", .price = 100, .qty = 3, .category = .food },
    .{ .name = "hammer", .price = 1500, .category = .tool }, // qty は既定値 0
    .{ .name = "bread", .price = 200, .qty = 2, .category = .food },
};

pub fn main(init: std.process.Init) !void {
    var buffer: [512]u8 = undefined;
    var w = std.Io.File.stdout().writer(init.io, &buffer);
    const out = &w.interface;

    // (1 + 2) * 4。ノードはスタック上に置き、ポインタで繋ぐ
    const one = Expr{ .num = 1 };
    const two = Expr{ .num = 2 };
    const four = Expr{ .num = 4 };
    const sum = Expr{ .add = .{ &one, &two } };
    const e = Expr{ .mul = .{ &sum, &four } };
    try out.print("(1 + 2) * 4 = {d}\n", .{eval(&e)});
    try out.print("total: {d}\n", .{totalValue(&sample)});
    try out.print("in stock: {d}\n", .{inStockCount(&sample)});
    if (find(&sample, "bread")) |b| try out.print("find bread: qty={d}\n", .{b.qty});
    if (find(&sample, "milk") == null) try out.print("find milk: none\n", .{});
    try out.print("first: {?s}\n", .{firstName(&sample)});
    const byCat = valueByCategory(&sample);
    try out.print("food: {d}, tool: {d}\n", .{ byCat.get(.food), byCat.get(.tool) });

    // ヒープを使う部分。GeneralPurposeAllocator (DebugAllocator) はリークを検出する
    var gpa: std.heap.DebugAllocator(.{}) = .init;
    defer _ = gpa.deinit();
    const alloc = gpa.allocator();
    const names = try namesSorted(alloc, &sample);
    defer alloc.free(names);
    try out.print("sorted: {s}, {s}, {s}\n", .{ names[0], names[1], names[2] });
    var m = try qtyMap(alloc, &sample);
    defer m.deinit();
    try out.print("hammer qty: {?d}\n", .{m.get("hammer")});
    try out.flush();
}

test "expr and slices" {
    const one = Expr{ .num = 1 };
    const two = Expr{ .num = 2 };
    const sum = Expr{ .add = .{ &one, &two } };
    try std.testing.expectEqual(3, eval(&sum));
    try std.testing.expectEqual(700, totalValue(&sample));
    try std.testing.expectEqual(2, inStockCount(&sample));
    try std.testing.expectEqual(null, firstName(&[_]Item{}));
}

test "allocating" {
    // std.testing.allocator はリークを検出する
    const names = try namesSorted(std.testing.allocator, &sample);
    defer std.testing.allocator.free(names);
    try std.testing.expectEqualStrings("apple", names[0]);
    var m = try qtyMap(std.testing.allocator, &sample);
    defer m.deinit();
    try std.testing.expectEqual(@as(?u32, 0), m.get("hammer"));
}
