# 06. モジュールとパッケージ

対応サンプル: [`examples/05-modules/`](../examples/05-modules/)

## 目的

MoonBit の「モジュール = 配布単位」「パッケージ = ディレクトリ」の 2 層構造と、import / 可視性のルールを理解する。

## 解説

### 構造

```
05-modules/
├── moon.mod                  # name = "learn/modules"
├── geometry/                 # パッケージ learn/modules/geometry
│   ├── moon.pkg
│   ├── geometry.mbt
│   └── shapes/               # パッケージ learn/modules/geometry/shapes (親とは別)
│       ├── moon.pkg          #   import { "learn/modules/geometry" }
│       └── shapes.mbt
├── units/                    # パッケージ learn/modules/units
└── cmd/main/                 # executable パッケージ
```

- パッケージのフルパスは `モジュール名/ディレクトリパス`。
- サブディレクトリは親パッケージとは **独立**。親の定義を使うには import が必要。

### import と参照

```
// cmd/main/moon.pkg
import {
  "learn/modules/geometry",
  "learn/modules/geometry/shapes" @shapes,   // 別名
  "learn/modules/units",
}
```

参照は `@geometry.circle_area(1.0)` / `@shapes.Circle::{ r: 1.0 }` のように `@名前.` を付ける。
既定の名前はパスの末尾 (`geometry`, `units`)。衝突するときは `@別名` を付ける。

外部モジュールへの依存は `moon.mod` の `import { "moonbitlang/x@0.4.6" }` に書く (`moon add` で追加できる)。

### 可視性

| 指定子 | 意味 |
|---|---|
| なし | パッケージ内のみ |
| `pub` | 他パッケージから見える。struct はフィールド読み取りのみ、trait は実装不可 |
| `pub(all)` | struct / enum の構築も他パッケージから可能 (`Circle::{ r: 1.0 }`) |
| `pub(open)` | trait を他パッケージで実装できる |

### 他パッケージの trait を実装する

```moonbit
pub impl @geometry.Shape for Circle with area(self) {
  @geometry.circle_area(self.r)
}
```

trait は `pub(open)`、impl 側は `pub impl` にすると、第三のパッケージからも `c.area()` が呼べる。

## 他の言語ではこう書く

Go のパッケージ (ディレクトリ = パッケージ、import パス) に最も近い。
Rust の `mod` のようにファイル内で宣言するのではなく、`moon.pkg` を置いたディレクトリが自動的にパッケージになる。

## 落とし穴

- `pub struct` だけでは他パッケージから `Circle::{ r: 1.0 }` と構築できない。`pub(all)` が必要。
- 循環 import はエラー。trait を親、実装を子に置くなど一方向にする。
- `moon check` は型検査だけ、`moon test` は全パッケージの `test` ブロックを実行する。
