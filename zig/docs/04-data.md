# 04. データ構造

対応サンプル: [`examples/03-data/`](../examples/03-data/)

## 目的

`struct` / `enum` / tagged union とスライスを使い、**アロケータを明示的に渡す** Zig のやり方を身につける。

## 最小コード

```zig
const Item = struct { name: []const u8, price: u32, qty: u32 = 0, category: Category };

const Expr = union(enum) {
    num: i64,
    add: [2]*const Expr,
    mul: [2]*const Expr,
};

fn eval(e: *const Expr) i64 {
    return switch (e.*) {
        .num => |n| n,
        .add => |ab| eval(ab[0]) + eval(ab[1]),
        .mul => |ab| eval(ab[0]) * eval(ab[1]),
    };
}

fn namesSorted(alloc: std.mem.Allocator, items: []const Item) ![][]const u8 {
    var list: std.ArrayList([]const u8) = .empty;
    for (items) |i| try list.append(alloc, i.name);
    return list.toOwnedSlice(alloc);
}
```

## 解説

### 型

| 型 | 書き方 | 備考 |
|---|---|---|
| struct | `struct { x: f32, qty: u32 = 0 }` | 既定値、メソッド (`pub fn`) を持てる |
| enum | `enum { food, tool }` | `@intFromEnum`、`std.EnumArray` のキー |
| tagged union | `union(enum) { num: i64, add: ... }` | 代数的データ型。`switch` で分解 |
| 配列 | `[3]u32` | 固定長、値型 |
| スライス | `[]const u32` | ポインタ + 長さ。関数の引数は基本これ |
| Optional | `?T` | |

再帰的な構造は自己参照ポインタ (`*const Expr`) で作る。ノードをスタックに置いてポインタで繋げるので、小さな木ならヒープ不要。

### アロケータ

ヒープを使う標準ライブラリの関数は、すべて `std.mem.Allocator` を引数に取る。

| アロケータ | 用途 |
|---|---|
| `std.heap.DebugAllocator` | 開発用。リーク・二重解放を検出 |
| `std.heap.page_allocator` | OS から直接 |
| `std.heap.ArenaAllocator` | まとめて解放。一時的な処理に |
| `std.heap.FixedBufferAllocator` | 固定バッファ上。組込みで |
| `std.testing.allocator` | テスト用。リークがあるとテスト失敗 |

`defer alloc.free(x)` / `defer list.deinit(alloc)` で解放を宣言と同じ場所に書くのが慣例。

### コレクション

`std.ArrayList(T)` (可変長配列、0.15 以降は unmanaged が既定で各操作に `alloc` を渡す)、`std.StringHashMap(V)`、`std.AutoHashMap(K, V)`、`std.EnumArray(E, V)`。
map / filter のような高階関数は標準にほぼなく、`for` で書く。

## 他の言語ではこう書く

Rust の `Vec` / `HashMap` はグローバルアロケータを暗黙に使う。Zig は毎回渡す。Rust `no_std` + `alloc` で `Vec::new_in(allocator)` と書くのに近い。

## 落とし穴

- `ArrayList` の API が 0.15 で変わった (`.init(alloc)` → `.empty` + 各操作に `alloc`)。
- スライスの比較 `==` はポインタ比較。内容の比較は `std.mem.eql`。
- `undefined` で初期化した配列を読むと未定義動作 (Debug では 0xAA で埋まる)。
