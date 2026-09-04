# 02. Hello, World

対応サンプル: [`examples/01-hello-world/`](../examples/01-hello-world/)

## 目的

Koka の構文 (インデントブロック) と、関数の型に効果が付くことを知る。

## 最小コード

```koka
fun main()
  println("Hello, World!")
```

## 実行

```sh
koka -e hello.kk
```

期待される出力:

```
Hello, World!
```

## 解説

| 要素 | 意味 |
|---|---|
| `fun main()` | 関数定義。本体はインデント (波括弧 `{ }` も使える) |
| `println` | `console` 効果を持つ。`main` の型は推論されて `() -> console ()` になる |
| 効果 | 型 `console ()` の `console` 部分。「この関数は標準出力に書きうる」 |

明示的に書くと `fun main() : console ()`。効果は推論されるので普段は書かない。

## 他の言語ではこう書く

Haskell の `main :: IO ()` に相当するが、Koka では `IO` が `console`, `fsys`, `net` などに細分化され、必要なものだけが型に現れる。

## 落とし穴

- インデントはスペース。タブは不可。
- `koka -e` は `.koka/` に C と実行ファイルを生成する。`.gitignore` に入れる。
