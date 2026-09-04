# Zig

> C の置き換えを狙うシステム言語。隠れた制御フロー・隠れたメモリ割り当てがなく、**comptime** (コンパイル時にZig のコードを実行する) でジェネリクスもメタプログラミングも実現する。

## なぜ今学ぶのか

- **comptime** という 1 つの仕組みで、ジェネリクス、条件コンパイル、テーブル生成、型検査を全部やる。マクロもテンプレートもない。
- **アロケータを明示的に渡す** 設計。どこでメモリを使うかが常に見え、`no_std` 相当が既定。
- **クロスコンパイルが標準**。`zig build -Dtarget=aarch64-linux` で他 OS / CPU 向けにそのままビルドできる。C コンパイラとしても使える (`zig cc`)。
- Bun、TigerBeetle、Ghostty など実運用のプロジェクトが増えている。

## セットアップ (最短)

```sh
curl -fsSL https://ziglang.org/download/0.16.0/zig-x86_64-linux-0.16.0.tar.xz | tar -xJ
export PATH=$PWD/zig-x86_64-linux-0.16.0:$PATH
zig version
```

## 章 5 (目玉概念) で扱うこと

- `comptime T: type` によるジェネリクス
- コンパイル時のテーブル生成、`@typeInfo` による型ごとのコード生成
- `anytype` + `@compileError`、`inline for` によるリフレクション

## 学習ロードマップ

| 章 | ドキュメント | サンプル | 学ぶこと |
|---|---|---|---|
| 0 | [docs/00-why.md](./docs/00-why.md) | — | 位置づけ、向く用途 |
| 1 | [docs/01-setup.md](./docs/01-setup.md) | — | インストール、バージョン固定 |
| 2 | [docs/02-hello-world.md](./docs/02-hello-world.md) | [examples/01-hello-world](./examples/01-hello-world/) | 最小プログラムとビルド |
| 3 | [docs/03-basics.md](./docs/03-basics.md) | [examples/02-basics](./examples/02-basics/) | 条件分岐を関数として書く |
| 4 | [docs/04-data.md](./docs/04-data.md) | [examples/03-data](./examples/03-data/) | データ構造・パターンマッチ |
| 5 | [docs/05-core.md](./docs/05-core.md) | [examples/04-core](./examples/04-core/) | **comptime** |
| 6 | [docs/06-modules.md](./docs/06-modules.md) | [examples/05-modules](./examples/05-modules/) | モジュールの扱い |
| 99 | [docs/99-resources.md](./docs/99-resources.md) | — | 公式資料・記事 |

## 検証

```sh
../scripts/check-zig.sh
```

## バージョン固定

`.tool-versions` に `zig 0.16.0`。Zig は 0.x で破壊的変更が多い (0.15 で I/O API が全面的に変わった)。
