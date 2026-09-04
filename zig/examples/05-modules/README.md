# 05 モジュール

## 学ぶこと

- **ファイル = struct**。`@import("file.zig")` はそのファイルを struct として返し、`pub` 宣言だけが見える
- **名前付きモジュール**: `build.zig` の `b.addModule("geometry", ...)` と `imports` で `@import("geometry")` を有効にする
- 同じモジュール内は相対パス `@import("shapes.zig")`、ルートは `@import("root.zig")`
- 「インターフェース」は tagged union + `inline else` で表す
- `zig build run` / `zig build test`

## 構成

```
05-modules/
├── build.zig                # モジュール定義、exe、run / test ステップ
└── src/
    ├── main.zig             # @import("geometry"), @import("units.zig")
    ├── units.zig
    └── geometry/
        ├── root.zig         # モジュールのルート。shapes.zig を再公開
        └── shapes.zig
```

## 実行

```sh
zig build run
zig build test
```

## 期待される出力

```
circle: 3.1416
rect:   2.0000
total:  5.1416
1.5m = 150cm
```
