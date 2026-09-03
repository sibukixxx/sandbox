# 06. モジュール

対応サンプル: [`examples/05-modules/`](../examples/05-modules/)

## 目的

OCaml のモジュールシステム (ファイル = モジュール、シグネチャ、ファンクタ、ファーストクラスモジュール) を理解する。OxCaml でも同じ。

## 解説

### ファイル = モジュール

```
lib/
├── dune          # (library (name geometry))
├── shape.ml      # → Geometry.Shape
├── shapes.ml     # → Geometry.Shapes
└── units.ml      # → Geometry.Units
```

- `shape.ml` はモジュール `Shape`。dune の library 名 `geometry` でラップされ、外からは `Geometry.Shape`。
- 同じライブラリ内では `Shape.circle_area` のように直接参照できる。
- `.mli` を書けばインターフェースを制限できる (書かなければ全て公開)。

### シグネチャと実装

```ocaml
module type S = sig
  type t
  val area : t -> float
  val name : string
end

module Circle : S with type t = float = struct
  type t = float
  let area r = circle_area r
  let name = "circle"
end
```

`with type t = float` で抽象型 `t` を具体化する。書かなければ `t` は外から中身の見えない型になる。

### ファンクタ

```ocaml
module Make (U : Unit) = struct
  let of_meters m = m *. U.factor
end
module Cm = Make (struct let name = "cm" let factor = 100.0 end)
```

モジュールを受け取ってモジュールを返す。設定や依存を差し替えた実装を作るのに使う。

### ファーストクラスモジュール

```ocaml
type packed = Packed : (module S with type t = 'a) * 'a -> packed
let area_of (Packed ((module M), v)) = M.area v
```

モジュールを値として持ち運べる。異なる図形を 1 つのリストに入れる (Rust の `dyn Trait` 相当) には、存在型を GADT で表す。

### open

- `open Geometry` はファイル全体、`Units.(Cm.show ...)` はその式だけに効くローカル open。

## 他の言語ではこう書く

Rust の trait + `dyn` はファーストクラスモジュール + GADT に、Rust のジェネリクスはファンクタに対応する。
OCaml のモジュールは「型を含む名前空間」であり、Rust の `mod` より強力 (ファンクタで抽象化できる)。

## 落とし穴

- dune の `(library (name geometry))` はモジュールを `Geometry.` でラップする。`(wrapped false)` で無効化できるが非推奨。
- ファンクタ適用の結果は毎回別の型を生む。`Cm.t` と `Mm.t` は同じ `float` でも、抽象化されていれば互換性がない。
- 循環依存はエラー。ファイル間の依存は一方向にする。
