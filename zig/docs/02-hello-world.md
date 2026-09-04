# 02. Hello, World

対応サンプル: [`examples/01-hello-world/`](../examples/01-hello-world/)

## 目的

Zig の `main` の形と、「標準出力に書く」だけでも明示的に行う設計を知る。

## 最小コード

```zig
const std = @import("std");

pub fn main(init: std.process.Init) !void {
    try std.Io.File.stdout().writeStreamingAll(init.io, "Hello, World!\n");
}
```

書式付き出力:

```zig
var buffer: [256]u8 = undefined;
var w = std.Io.File.stdout().writer(init.io, &buffer);
const out = &w.interface;
try out.print("Hello, {s}!\n", .{"Zig"});
try out.flush();
```

## 実行

```sh
zig run hello.zig
```

期待される出力:

```
Hello, World!
Hello, Zig! (1 + 2 = 3)
```

## 解説

| 要素 | 意味 |
|---|---|
| `@import("std")` | 標準ライブラリ。`@` で始まるのは組込み関数 |
| `pub fn main(init: std.process.Init) !void` | `init.io` が I/O の入口。`!void` は「エラーを返しうる」 |
| `try` | エラーなら呼び出し元にそのまま返す |
| `writer(init.io, &buffer)` | バッファ付き Writer。自分でバッファを用意する = 隠れた割り当てがない |
| `out.print("{s}", .{...})` | 書式は comptime に検査される。`.{}` は無名タプル |
| `flush()` | バッファを書き出す。忘れると何も出ない |

`std.debug.print` (stderr、バッファ不要) の方が手軽で、デバッグ出力にはこちらを使う。

## 他の言語ではこう書く

Rust の `println!` はマクロで、内部で stdout のロックとバッファを隠している。Zig はそれを全部見せる。

## 落とし穴

- Zig 0.15 以前は `std.io.getStdOut().writer()`。0.15 で `std.fs.File.stdout().writer(&buf)`、0.16 で `std.Io.File.stdout().writer(io, &buf)` と変わった。
- `main` が `void` を返すなら `try` は使えない (`!void` にする)。
