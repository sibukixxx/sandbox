# 06. モジュール

対応サンプル: [`examples/05-modules/`](../examples/05-modules/)

## 目的

ファイルとモジュールの対応、`import` の 3 形式、`opaque type` による抽象化を学ぶ。

## 解説

### ファイルパス = モジュール名

`src/geometry/shape.gleam` はモジュール `geometry/shape`。`src/geometry.gleam` は `geometry` で、両者に親子関係はない (別のモジュール)。

### import

```gleam
import geometry/shape                 // shape.area で参照 (最後の要素が接頭辞)
import geometry/shape.{Circle, Rect}  // 名前を直接使う。型は .{type Shape}
import units as u                     // 別名
```

### 可視性

`pub` を付けた関数・型・定数だけが外から見える。既定は非公開。

### opaque type

```gleam
pub opaque type Meters {
  Meters(Float)
}

pub fn meters(v: Float) -> Result(Meters, String) { ... }
```

型 `Meters` は公開されるが、コンストラクタ `Meters(...)` はモジュール内でしか使えない。外部は `meters(1.5)` (スマートコンストラクタ) でしか値を作れず、「負の長さは存在しない」という不変条件をモジュールが保証する。

### ドキュメントコメント

`////` はモジュール、`///` は直後の定義のドキュメント。`gleam docs build` で HTML になる。

## 他の言語ではこう書く

OCaml の `.mli` で型を抽象にするのと同じことを、Gleam は `opaque` キーワード 1 つで行う。Rust の `pub struct Meters(f32)` でフィールドを非公開にするのと同じ効果。

## 落とし穴

- `import geometry/shape` の後は `shape.area`。`geometry.shape.area` ではない。
- 循環 import はエラー。
- `src/` 以下のファイルはすべてモジュールとしてコンパイルされる。
