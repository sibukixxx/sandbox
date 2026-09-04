# 03 データ構造とパターンマッチ

## 学ぶこと

- `enum` / `struct` (既定値付き) / `union(enum)` (代数的データ型)
- 再帰構造は自己参照ポインタ (`*const Expr`)。ノードをスタックに置ける
- `switch` で tagged union を分解 (`|v|` でペイロード)
- スライス `[]const T` と `for`。map / filter は for で書く
- `std.EnumArray` で enum をキーにした集計
- **アロケータを明示的に渡す**: `ArrayList` / `StringHashMap`、`defer` で解放、`DebugAllocator` と `testing.allocator` のリーク検出

## 実行

```sh
zig run data.zig
zig test data.zig
```

## 期待される出力

```
(1 + 2) * 4 = 12
total: 700
in stock: 2
find bread: qty=2
find milk: none
first: apple
food: 700, tool: 0
sorted: apple, bread, hammer
hammer qty: 0
All 2 tests passed.
```
