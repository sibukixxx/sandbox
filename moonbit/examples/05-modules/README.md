# 05 モジュールとパッケージ

## 学ぶこと

- **モジュール** (`moon.mod`, 配布単位) と **パッケージ** (`moon.pkg`, ディレクトリ単位) の 2 層構造
- `moon.pkg` の `import { ... }` と `@名前` による参照、別名 (`@shapes`)
- 可視性: なし (パッケージ内) / `pub` (読み取り公開) / `pub(all)` (構築も公開) / `pub(open)` (trait を外部で実装可)
- 他パッケージの trait を `pub impl ... for ... with` で実装する
- サブディレクトリでも親パッケージは自動では見えず、必ず import する

## 構成

```
05-modules/
├── moon.mod                  # モジュール "learn/modules"
├── geometry/                 # パッケージ learn/modules/geometry (trait Shape)
│   ├── moon.pkg
│   ├── geometry.mbt
│   └── shapes/               # パッケージ learn/modules/geometry/shapes (Circle, Rect)
│       ├── moon.pkg          #   → geometry を import
│       └── shapes.mbt
├── units/                    # パッケージ learn/modules/units (Meters)
└── cmd/main/                 # executable パッケージ。上の 3 つを import
```

## 実行

```sh
moon check          # 型検査だけ
moon test           # 全パッケージの test ブロック
moon run cmd/main
```

## 期待される出力

```
circle: 3.141592653589793
rect:   2
total:  5.141592653589793
1.5m = 150cm
```
