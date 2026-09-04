# 01 Hello, World

## 学ぶこと

- `pub fn main(init: std.process.Init) !void`: `init.io` が I/O の入口。`!` はエラーを返しうる (エラー共用体)
- `try`: エラーならそのまま呼び出し元へ返す
- 標準出力は Writer をバッファ付きで作り、`flush` する
- `zig run` (ビルドして実行) と `zig build-exe` (実行ファイルを作る)

## 実行

```sh
zig run hello.zig
zig build-exe hello.zig -O ReleaseSmall && ./hello && ls -l hello
```

## 期待される出力

```
Hello, World!
Hello, Zig! (1 + 2 = 3)
```
