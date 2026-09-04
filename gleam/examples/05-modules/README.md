# 05 モジュール

## 学ぶこと

- **ファイルパス = モジュール名** (`src/geometry/shape.gleam` → `geometry/shape`)
- `import geometry/shape` (最後の要素で参照)、`.{Circle, Rect}` (直接参照)、`as u` (別名)
- `pub` を付けたものだけ公開。既定は非公開
- **`pub opaque type`**: 型は公開しコンストラクタは隠す。スマートコンストラクタで不変条件を守る
- `////` はモジュールのドキュメントコメント、`///` は定義のドキュメントコメント

## 構成

```
05-modules/src/
├── modules.gleam        # main。各モジュールを import
├── geometry.gleam       # module geometry (total_area)
├── geometry/
│   └── shape.gleam      # module geometry/shape (Shape, area)
└── units.gleam          # module units (opaque Meters)
```

## 実行

```sh
gleam run
```

## 期待される出力

```
circle: 3.141592653589793
rect:   2.0
total:  5.141592653589793
1.5m = 150.0cm
error: negative length
```
