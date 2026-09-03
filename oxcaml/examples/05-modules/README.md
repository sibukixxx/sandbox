# 05 モジュール

## 学ぶこと

- **ファイル = モジュール**。`lib/shape.ml` は `Geometry.Shape` になる (dune の library 名でラップ)
- `module type` (シグネチャ) と `module M : S = struct ... end`
- `with type t = ...` で抽象型を具体化する
- **ファーストクラスモジュール** (`(module M)`) と GADT で異種の図形を 1 つのリストに入れる
- **ファンクタ** (`module Make (U : Unit) = struct ... end`)
- `open` / ローカル open (`Units.(...)`)

## 構成

```
05-modules/
├── dune-project
├── lib/
│   ├── dune            # (library (name geometry))
│   ├── shape.ml        # module type S, ヘルパー
│   ├── shapes.ml       # Circle, Rect, packed, total_area
│   └── units.ml        # ファンクタ Make, Cm, Mm
└── bin/
    ├── dune            # (libraries geometry)
    └── main.ml
```

## 実行

```sh
dune build && dune exec ./bin/main.exe
```

dune がない場合 (ラップなしなので `Geometry.` を外して読む):

```sh
cd lib && ocamlopt -c shape.ml shapes.ml units.ml && cd .. && \
  sed 's/^open Geometry$//' bin/main.ml > /tmp/main.ml && \
  ocamlopt -I lib lib/shape.cmx lib/shapes.cmx lib/units.cmx /tmp/main.ml -o main && ./main
```

## 期待される出力

```
circle: 3.14159
rect:   2
total:  5.14159
150cm
1500mm
```
