# 06. モジュール

対応サンプル: [`examples/05-modules/`](../examples/05-modules/)

## 目的

Koka のモジュールがファイルパスと対応すること、`pub` と `import`、名前の衝突の解決を学ぶ。

## 解説

### ファイルパス = モジュール名

`geometry/shape.kk` はモジュール `geometry/shape`。先頭で `module geometry/shape` と宣言する (省略すると include パスからの相対パスで決まる)。
`-i` オプションで探索の起点を指定する: `koka -i. -e main.kk`。

### 可視性

`pub` を付けた型・関数・struct だけが外から見える。既定は非公開。struct を `pub` にするとコンストラクタとアクセサも公開される。

### import

```koka
import geometry/shape
import units
import std/num/float64
```

import した名前は修飾なしで使える。曖昧なときはモジュール名で修飾する: `shape/area(c)`、`units/show(m)`。
モジュール名の最後の要素だけでも修飾できる (`shape/area`)。

### 標準ライブラリ

`std/core` は自動で import される。`float64`、`std/os/file`、`std/text/regex` などは明示的に import する。

## 他の言語ではこう書く

OCaml と同じく「ファイル = モジュール」だが、OCaml の `open` に相当するのが `import` で、既定で修飾なし参照になる。Rust の `mod` 宣言は不要で、Go に近い。

## 落とし穴

- `show` のような標準にもある名前を定義すると、使う側で必ず修飾が要る。
- `import` したモジュールのファイルが include パスから見つからないと `module not found`。`-i` を確認する。
- `.koka/` 以下に各モジュールの生成物が入る。
