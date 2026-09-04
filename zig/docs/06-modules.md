# 06. モジュール

対応サンプル: [`examples/05-modules/`](../examples/05-modules/)

## 目的

「ファイル = struct」という Zig のモジュール観と、`build.zig` で名前付きモジュールを定義する方法を理解する。

## 解説

### ファイルは struct

`@import("shapes.zig")` は、そのファイル全体を 1 つの struct として返す。トップレベルの `pub` 宣言がそのフィールド (定数) になる。

```zig
const shapes = @import("shapes.zig");
const c = shapes.Circle{ .r = 1 };
```

`pub` がない宣言はファイルの外から見えない。これが唯一の可視性制御。

### 名前付きモジュール

パスではなく名前で `@import("geometry")` するには、`build.zig` で登録する。

```zig
const geometry = b.addModule("geometry", .{ .root_source_file = b.path("src/geometry/root.zig"), ... });
const exe = b.addExecutable(.{
    .root_module = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .imports = &.{.{ .name = "geometry", .module = geometry }},
    }),
});
```

外部パッケージ (`build.zig.zon` の依存) も同じ仕組みで `imports` に入る。

### モジュール内の参照

- 子ファイル: `@import("shapes.zig")` (相対パス)
- ルート: `@import("root.zig")`。同じモジュール内なら循環 import も可
- 再公開: ルートで `pub const Circle = shapes.Circle;` とすると `geometry.Circle` で使える

### インターフェース

Zig に trait / interface はない。代わりに:

- **tagged union** + `inline else`: 型の集合が閉じているとき
- **vtable を持つ struct** (`std.mem.Allocator` の実装方式): 開いているとき
- **comptime ジェネリクス**: コンパイル時に決まるとき

### テスト

各ファイルの `test` ブロックは、`zig build test` で `addTest` したモジュールから到達可能なものが走る。ルートに `test { std.testing.refAllDecls(@This()); }` を置くと全宣言のテストが対象になる。

## 他の言語ではこう書く

Rust の `mod` はモジュールツリーを宣言で作るが、Zig は `@import` の連鎖がそのままツリー。Rust の `Cargo.toml` に相当するのが `build.zig` + `build.zig.zon` で、ビルド手順そのものを Zig で書く。

## 落とし穴

- `build.zig` の API はリリースごとに変わる (`addExecutable` の引数が 0.14 → 0.15 で `root_module` 方式になった)。
- `@import` はファイルがモジュールのルートから到達可能でなければ使えない (パッケージ外のファイルを `../` で参照できない)。
- `zig build` の生成物は `zig-out/`、キャッシュは `.zig-cache/`。`.gitignore` に入れる。
