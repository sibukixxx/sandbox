# 05 モジュールと namespace

## 学ぶこと

- **ファイルモジュール**: `Geometry/Shapes.lean` = `import Geometry.Shapes`。`lakefile.toml` の `lean_lib` がルート
- **namespace**: 名前の接頭辞。ファイルとは独立で、複数ファイルにまたがってもよい
- `open Geometry` / `open Geometry in` で接頭辞を省略
- `private` (ファイル内限定)、`Circle.describe` によるドット記法
- 型クラス (`class` / `instance`) を別ファイルで実装する

## 構成

```
05-modules/
├── lakefile.toml        # lean_lib "Geometry" と lean_exe "modules"
├── Geometry.lean        # ライブラリのルート。子モジュールを import するだけ
├── Geometry/
│   ├── Basic.lean       # namespace Geometry: class Shape, circleArea
│   └── Shapes.lean      # namespace Geometry: Circle, Rect, instance / namespace Units
└── Main.lean            # import Geometry して使う
```

## 実行

```sh
lake build && lake exe modules
```

## 期待される出力

```
circle r=1.000000 area=3.141593
rect:  2.000000
total: 5.141593
1.5m = 150.000000cm
```
