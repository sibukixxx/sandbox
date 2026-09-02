# 05 モジュール

## 学ぶこと

- `include "Geometry.dfy"` で別ファイルを読み込む
- `module` による名前空間、`import M` / `import opened M` / `import X = M`
- `export provides / reveals` で公開する名前と、定義まで見せるかを制御する
- `abstract module` + `refines` で仕様と実装を分け、実装が仕様を満たすことを検証させる

## 構成

```
05-modules/
├── Geometry.dfy   # module Geometry
└── modules.dfy    # include + module Units / Counter / Counter3 / Main
```

## 実行

```sh
dafny run modules.dfy
```

## 期待される出力

```
Dafny program verifier finished with 2 verified, 0 errors
total: 5
1.5m (as 150cm): 150
1 2 3 0 1
```
