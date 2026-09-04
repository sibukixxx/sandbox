# 04 comptime (コンパイル時実行)

## 学ぶこと

- `comptime T: type` でジェネリクス。型を返す関数 = ジェネリック型 (`Stack(i32, 4)`)
- コンパイル時にテーブルを生成し、定数として埋め込む
- `@typeInfo` / `@TypeOf` で型に応じたコードを生成する
- `anytype` + `@compileError` で型安全な汎用関数
- `std.meta.fields` + `inline for` で構造体を走査 (実行時コストゼロのリフレクション)
- `comptime var` / `inline while`

## 実行

```sh
zig run comptime.zig
zig test comptime.zig
```

## 期待される出力

```
pop: 20 10 null
squares: { 0, 1, 4, 9, 16, 25, 36, 49, 64, 81 }
i32: signed int, u8: unsigned int, []u8: slice, ?f32: optional
sum: 6 4.0
fields: x y label
bits(0b1011): 3
All 2 tests passed.
```

## 試してみる

`main` のコメント `sum([_][]const u8{"a"})` を有効にすると、`@compileError` のメッセージがコンパイル時に出る。
