# 06. モジュールと namespace

対応サンプル: [`examples/05-modules/`](../examples/05-modules/)

## 目的

Lean の 2 つの仕組み、**ファイルモジュール** (`import`) と **namespace** (名前の接頭辞) を区別して使う。

## 解説

### ファイルモジュール

```
05-modules/
├── lakefile.toml        # [[lean_lib]] name = "Geometry"
├── Geometry.lean        # import Geometry.Basic / import Geometry.Shapes
├── Geometry/
│   ├── Basic.lean
│   └── Shapes.lean      # import Geometry.Basic
└── Main.lean            # import Geometry
```

- ファイル `Geometry/Shapes.lean` はモジュール `Geometry.Shapes`。ディレクトリ区切りが `.` になる。
- `lakefile.toml` の `lean_lib` の名前がルートファイル (`Geometry.lean`) を決める。
- `import` は推移的でない。`Main.lean` が `Geometry.Shapes` の中身を使うには、`Geometry.lean` がそれを import している必要がある。

### namespace

```lean
namespace Geometry
  class Shape (α : Type) where
    area : α → Float
  def circleArea (r : Float) : Float := ...
end Geometry
```

- `Geometry.circleArea` のように接頭辞が付く。ファイルとは無関係で、複数ファイルで同じ namespace を開いてよい。
- `open Geometry` で接頭辞を省略。`open Geometry in def ...` は 1 宣言だけに効く。
- `private def` はそのファイル内でのみ見える。
- `def Circle.describe (c : Circle)` と定義すると、`c.describe` (ドット記法) で呼べる。namespace `Circle` に置くのと同じ。

### 型クラス

`class Shape` を `Basic.lean` に、`instance : Shape Circle` を `Shapes.lean` に置ける。
インスタンスは import した先で自動的に見つかる。

## 他の言語ではこう書く

Rust の `mod` はファイルと名前空間が一体だが、Lean は分離している。
`namespace` は C++ の namespace、`import` は Python の import に近い。

## 落とし穴

- `import` はファイルの先頭にしか書けない。ドキュメントコメント `/-! -/` より前に置く。
- `/-- -/` (宣言用ドキュメントコメント) は `namespace` の前には置けない。`--` か `/-! -/` を使う。
- namespace 内で `Shape` と書けても、外からは `Geometry.Shape` と書くか `open` が必要。
