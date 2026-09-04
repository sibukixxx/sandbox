# 03. 条件分岐を関数として書く

対応サンプル: [`examples/02-basics/`](../examples/02-basics/)

## 目的

`if` / `switch` が式であること、Optional とエラー共用体で「値なし」「失敗」を分岐として扱うことを学ぶ。

## 最小コード

```zig
fn sign(x: i32) []const u8 {
    return if (x > 0) "positive" else if (x < 0) "negative" else "zero";
}

fn classify(x: i32) []const u8 {
    return switch (x) {
        0 => "zero",
        1...9 => "small",
        else => if (x < 0) "negative" else "large",
    };
}

fn checkedDiv(a: i32, b: i32) ?i32 {
    return if (b == 0) null else @divTrunc(a, b);
}

const DivError = error{DivisionByZero};
fn safeDiv(a: i32, b: i32) DivError!i32 {
    if (b == 0) return error.DivisionByZero;
    return @divTrunc(a, b);
}
```

## 解説

- **`if` / `switch` は式**。`return if (...) a else b;` と書ける。`switch` は範囲 `1...9`、複数値 `0, 10`、`else` を持ち、網羅性はコンパイラが検査する。
- **タプルの switch はない**。複数条件は bool を組み合わせるか、ネストする。
- **Optional `?T`**: `null` が値なし。`orelse` で既定値 / 早期 return、`if (opt) |v|` で中身を取り出す。
- **エラー共用体 `E!T`**: 「なぜ失敗したか」を持つ。`try` で伝播、`catch |err|` で処理。エラーは値であり、例外のような巻き戻しはない。
- **整数演算は明示的**: `/` は符号付き整数に使えず `@divTrunc` / `@divFloor` を選ぶ。オーバーフローは Debug ビルドでパニック。
- **コンパイル時評価**: 引数が定数なら通常の関数もコンパイル時に評価される (`const ABS_MIN = abs(-7)`)。
- **テスト**: `test "name" { try std.testing.expectEqual(...); }` をソースに書き、`zig test` で実行。

## 他の言語ではこう書く

Rust の `Option` / `Result` に相当するのが `?T` / `E!T`。Rust の `?` が Zig の `try`。Zig にはパターンマッチ (`match`) がなく、`switch` と `if (opt) |v|` で代用する。

## 落とし穴

- `switch` の `else` を書き忘れると、網羅していない旨のコンパイルエラー (整数は全値を列挙できないので必須)。
- `@intCast` などの型変換は明示的。`u32` を `i32` の引数に渡せない。
- 文字列は `[]const u8` (バイトのスライス)。比較は `std.mem.eql`。
