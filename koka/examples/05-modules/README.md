# 05 モジュール

## 学ぶこと

- **ファイルパス = モジュール名** (`geometry/shape.kk` → `module geometry/shape`)
- `pub` を付けたものだけ公開。既定は非公開
- `import geometry/shape` で取り込み、`shape/area` のようにモジュール名で修飾できる
- 名前の衝突 (`show`) はモジュール名で解決する
- `-i` (include パス) でモジュールの探索場所を指定する

## 構成

```
05-modules/
├── main.kk              # import geometry/shape, import units
├── units.kk             # module units
└── geometry/
    └── shape.kk         # module geometry/shape
```

## 実行

```sh
koka -i. -e main.kk
```

## 期待される出力

```
circle: 3.1415926535897931
rect:   2
total:  5.1415926535897931
1.5m = 150cm
```
