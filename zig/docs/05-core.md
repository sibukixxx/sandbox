# 05. comptime

対応サンプル: [`examples/04-core/`](../examples/04-core/)

## 目的

Zig の中心である comptime を、ジェネリクス → テーブル生成 → 型情報による分岐 → リフレクションの順に体験する。

## 最小コード

```zig
fn Stack(comptime T: type, comptime capacity: usize) type {
    return struct {
        items: [capacity]T = undefined,
        len: usize = 0,
        pub fn push(self: *@This(), v: T) !void { ... }
    };
}

var s = Stack(i32, 4){};
```

## 解説

### 型は値

`type` 型の値 (`i32`, `[]const u8`, 自作 struct) は comptime に扱える。型を受け取って型を返す関数が「ジェネリック型」になる。`Stack(i32, 4)` は呼ぶたびに同じ型を返す (メモ化される)。

### comptime で計算する

```zig
fn makeSquares(comptime n: usize) [n]u32 { ... }
const squares = makeSquares(10);   // コンパイル時に計算され、定数として埋め込まれる
```

`comptime` 引数や `const` の初期化式はコンパイル時に評価される。ループ、分岐、関数呼び出しがそのまま使える。ルックアップテーブル、CRC テーブル、状態遷移表などに使う。

### 型情報で分岐する

```zig
fn describe(comptime T: type) []const u8 {
    return switch (@typeInfo(T)) {
        .int => |info| if (info.signedness == .signed) "signed int" else "unsigned int",
        .pointer => |p| if (p.size == .slice) "slice" else "pointer",
        else => "other",
    };
}
```

`@typeInfo` は型の構造 (整数か、ポインタか、struct のフィールドは何か) を comptime に返す。これで型ごとに違うコードを生成する。シリアライザ、フォーマッタ、ORM がこの仕組みで書かれる。

### anytype と @compileError

```zig
fn sum(xs: anytype) @TypeOf(xs[0]) {
    comptime if (@typeInfo(@TypeOf(xs[0])) != .int and ...) @compileError("sum requires numbers");
    ...
}
```

`anytype` は「呼び出し側の型で単相化する」引数。型の制約は `@compileError` で自分で書く。エラーメッセージは自分の言葉で出せる。

### inline for によるリフレクション

```zig
inline for (std.meta.fields(T), 0..) |f, i| names[i] = f.name;
```

`inline for` はコンパイル時に展開される。struct のフィールドを走査するコードが、実行時にはフィールド数分のストレートなコードになる。

## 他の言語ではこう書く

| 目的 | Zig | 他 |
|---|---|---|
| ジェネリクス | `comptime T: type` | Rust ジェネリクス、C++ テンプレート |
| 条件コンパイル | `if (comptime ...)` / `comptime` ブロック | C `#ifdef`、Rust `cfg` |
| コード生成 | comptime 関数 | Rust マクロ、C++ constexpr |
| リフレクション | `@typeInfo` | Rust `derive` マクロ、Go reflect (実行時) |

Zig は「特別な言語」を追加せず、通常の Zig コードをコンパイル時に走らせるだけで全部を賄う。読みやすさとデバッグしやすさがマクロと違う。

## 落とし穴

- comptime で使える値は comptime に決まっている必要がある。実行時の値を `comptime` 引数に渡すとエラー。
- comptime の評価には分岐量の上限がある (`@setEvalBranchQuota` で増やす)。
- `anytype` は型を隠すので、公開 API では `comptime T: type` で明示する方が読みやすい。
