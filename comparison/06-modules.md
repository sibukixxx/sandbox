# 06. モジュールの扱い、を 7 言語で

## 結論 (一覧表)

| 言語 | モジュールの単位 | 宣言の仕方 | 取り込み | 可視性の既定 | 公開の指定 | 特徴的な機能 |
|---|---|---|---|---|---|---|
| MoonBit | ディレクトリ = パッケージ、`moon.mod` = モジュール (配布単位) | `moon.pkg` を置く | `moon.pkg` の `import { "path" @alias }` → `@alias.f` | 非公開 | `pub` / `pub(all)` / `pub(open)` | 3 段階の `pub`。trait の外部実装を制御 |
| OxCaml | ファイル = モジュール | 自動 (+ `module M = struct end`) | `open M` / `M.f` / ローカル open `M.(...)` | 公開 (`.mli` で制限) | `.mli` / `sig` | ファンクタ、ファーストクラスモジュール |
| Lean 4 | ファイル = モジュール、`namespace` は別 | `namespace X ... end X` | `import A.B` (先頭のみ) / `open X` | 公開 | `private` | ファイルと名前空間が独立。ドット記法 |
| Quint | `module { }` (ファイル内に複数可) | `module M { }` | `import M.*` / `import M as X` / `from "./file"` | 公開 | (`export` で再公開) | `const` を持つモジュールの **instance 化** |
| Verse | フォルダ = モジュール (+ `:= module:`) | フォルダに置く | `using { Path }` | `<internal>` | `<public>` | 標準モジュールもパス (`/Verse.org/...`) |
| Dafny | `module { }` | `module M { }` / `include "file"` | `import M` / `import opened M` / `import X = M` | 公開 | `export provides / reveals` | `abstract module` + `refines` で仕様と実装を分離 |
| Rust no_std | `mod` 宣言 (ファイル or インライン) | `mod m;` / `mod m { }` | `use path` / `pub use` (再エクスポート) | 非公開 | `pub` / `pub(crate)` | feature フラグで `no_std` → `alloc` → `std` |

## 言語ごとのコード

題材は共通で「`Shape` (Circle / Rect) を別モジュールに置き、main から使う」。

### MoonBit → [examples](../moonbit/examples/05-modules/)

```
// cmd/main/moon.pkg
import {
  "learn/modules/geometry",
  "learn/modules/geometry/shapes" @shapes,
}
```

```moonbit
pub(open) trait Shape { area(Self) -> Double }            // geometry/
pub impl @geometry.Shape for Circle with area(self) { ... } // geometry/shapes/
let c = @shapes.Circle::{ r: 1.0 }                          // cmd/main/
```

ディレクトリがそのままパッケージ。サブディレクトリも親とは独立で、必ず import する。

### OxCaml → [examples](../oxcaml/examples/05-modules/)

```ocaml
(* lib/shape.ml → Geometry.Shape *)
module type S = sig type t val area : t -> float end

(* lib/shapes.ml *)
module Circle : Shape.S with type t = float = struct
  type t = float
  let area r = Shape.circle_area r
end

(* lib/units.ml: ファンクタ *)
module Make (U : Unit) = struct let of_meters m = m *. U.factor end
module Cm = Make (struct let name = "cm" let factor = 100.0 end)
```

ファイルが自動的にモジュールになる。シグネチャ、ファンクタ、ファーストクラスモジュールと、モジュールが「型を含む値」として最も強力。

### Lean 4 → [examples](../lean/examples/05-modules/)

```lean
-- Geometry/Basic.lean
namespace Geometry
class Shape (α : Type) where area : α → Float
end Geometry

-- Geometry/Shapes.lean
import Geometry.Basic
namespace Geometry
structure Circle where r : Float
instance : Shape Circle where area c := circleArea c.r
end Geometry

-- Main.lean
import Geometry
open Geometry in
def totalArea (c : Circle) (r : Rect) : Float := Shape.area c + Shape.area r
```

`import` (ファイル) と `namespace` (名前) が独立している。`Circle.describe` と定義すれば `c.describe` と呼べる。

### Quint → [examples](../quint/examples/05-modules/)

```quint
module main {
  import geometry.* from "./geometry"
  import units as u
  import counter(MAX = 3) as c3      // const に値を与えて instance 化
  import counter(MAX = 10) as c10
  action step = all { c3::step, c10::step }
}
```

`const` を持つモジュールを instance 化して複数個並べる。分散システムの「ノード N 個」をこの方法で表す。

### Verse → [examples](../verse/examples/05-modules/) (UEFN 未確認)

```verse
# Geometry/shapes.verse → using { Geometry }
shape<public> := interface:
    Area<public>():float
circle<public> := class(shape):
    Radius<public>:float = 1.0
    Area<override>():float = 3.14159 * Radius * Radius

# modules_device.verse
using { Geometry }
Units := module:
    ToCm<public>(Meters:float):float = Meters * 100.0
```

フォルダがそのままモジュール。既定が `<internal>` なので、外に出すものすべてに `<public>` が要る。

### Dafny → [examples](../dafny/examples/05-modules/)

```dafny
include "Geometry.dfy"

module Units {
  export provides ToCm reveals Meters
  type Meters = int
  function ToCm(m: Meters): int { m * 100 }
}

abstract module Counter {
  const MAX: int
  method Next(n: int) returns (m: int) requires 0 <= n <= MAX ensures 0 <= m <= MAX
}
module Counter3 refines Counter {
  const MAX := 3
  method Next(n: int) returns (m: int) { if n < MAX { m := n + 1; } else { m := 0; } }
}
```

`export provides` は「存在だけ」、`reveals` は「定義まで」公開。`abstract module` + `refines` で、実装が仕様 (契約) を満たすことを検証する。

### Rust (no_std) → [examples](../rust-no-std/examples/05-modules/)

```rust
// src/lib.rs
#![cfg_attr(not(any(test, feature = "std")), no_std)]
#[cfg(feature = "alloc")] extern crate alloc;
pub mod geometry;                       // src/geometry/mod.rs
pub use geometry::shapes::{Circle, Rect};

// src/geometry/mod.rs
pub mod shapes;
pub trait Shape { fn area(&self) -> f32; }
pub(crate) fn square(x: f32) -> f32 { x * x }
```

`mod` を書いた場所がツリーを決める。feature フラグで `no_std` → `alloc` → `std` を段階的に有効化するのがライブラリの定石。

## 違いはどこから来るか

1. **「モジュールは何に対応するか」が 3 派に分かれる**。ファイル / ディレクトリ (OCaml, Lean, MoonBit, Verse)、明示的な宣言 (Rust, Dafny, Quint)、両方 (Lean の namespace, Verse の `:= module:`)。
2. **既定が公開か非公開か**。Rust, MoonBit, Verse は非公開が既定で、公開するものに印を付ける。OCaml, Lean, Dafny, Quint は公開が既定で、隠すものに印を付ける (`.mli`, `private`, `export`)。
3. **モジュールが「値」になるか**。OCaml (ファンクタ、ファーストクラスモジュール) と Quint (instance 化) はモジュールをパラメータ化できる。Dafny は `refines` で仕様と実装を分ける。Rust / MoonBit は trait でその役割を担う。
4. **公開の粒度**。MoonBit の `pub` / `pub(all)` / `pub(open)` と Dafny の `provides` / `reveals` は「見える」と「使える / 中身を知れる」を区別する。他の言語は 2 値。

## どれを選ぶか

| こういう人 | この言語 |
|---|---|
| モジュールシステムそのものを学びたい | OxCaml (OCaml) |
| 「ディレクトリ = パッケージ」の分かりやすさが欲しい | MoonBit, Verse |
| 仕様と実装を分けて検証したい | Dafny |
| 同じ部品を N 個並べて振る舞いを検証したい | Quint |
