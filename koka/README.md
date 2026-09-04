# Koka

> Microsoft Research の Daan Leijen が設計した、**代数的効果とハンドラ** を言語の中心に据えた関数型言語。例外・状態・非同期・非決定性を「効果」という 1 つの仕組みで表す。

## なぜ今学ぶのか

- **効果型**: 関数の型に「何をしうるか」(`<console, exn, div>`) が現れる。純粋な関数と副作用のある関数を型で区別できる。
- **代数的効果とハンドラ**: 効果の「宣言」と「意味」を分け、同じコードに違うハンドラを当てて振る舞いを変えられる。例外、状態、ジェネレータ、async、依存性注入がすべてこれで書ける。Verse や OCaml 5 の効果、Rust の async の設計を理解する土台になる。
- **Perceus**: 参照カウントによるメモリ管理で、GC なしに関数型のコードを in-place 更新に最適化する (Koka 独自の研究成果)。
- C にコンパイルされ、生成物は小さく速い。

## セットアップ (最短)

```sh
curl -fsSL https://github.com/koka-lang/koka/releases/download/v3.2.2/koka-v3.2.2-linux-x64.tar.gz | tar -xz
export PATH=$PWD/bin:$PATH
koka --version
```

## 章 5 (目玉概念) で扱うこと

- `effect` の宣言 (`fun` / `ctl` 操作)、効果型
- `with` によるハンドラ、同じ関数への複数のハンドラ
- `resume` を使わない (例外)、1 回使う (回復・状態)、複数回使う (非決定性)

## 学習ロードマップ

| 章 | ドキュメント | サンプル | 学ぶこと |
|---|---|---|---|
| 0 | [docs/00-why.md](./docs/00-why.md) | — | 位置づけ、向く用途 |
| 1 | [docs/01-setup.md](./docs/01-setup.md) | — | インストール、バージョン固定 |
| 2 | [docs/02-hello-world.md](./docs/02-hello-world.md) | [examples/01-hello-world](./examples/01-hello-world/) | 最小プログラムとビルド |
| 3 | [docs/03-basics.md](./docs/03-basics.md) | [examples/02-basics](./examples/02-basics/) | 条件分岐を関数として書く |
| 4 | [docs/04-data.md](./docs/04-data.md) | [examples/03-data](./examples/03-data/) | データ構造・パターンマッチ |
| 5 | [docs/05-core.md](./docs/05-core.md) | [examples/04-core](./examples/04-core/) | **代数的効果とハンドラ** |
| 6 | [docs/06-modules.md](./docs/06-modules.md) | [examples/05-modules](./examples/05-modules/) | モジュールの扱い |
| 99 | [docs/99-resources.md](./docs/99-resources.md) | — | 公式資料・記事 |

## 検証

```sh
../scripts/check-koka.sh
```

## バージョン固定

`.tool-versions` に `koka 3.2.2`。
