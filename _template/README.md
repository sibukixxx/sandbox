# {{言語名}}

> {{一言で。例: WASM ファーストの関数型寄り汎用言語}}

## なぜ今学ぶのか

{{3〜5 行。何が新しく、どこで差がつくか。詳細は docs/00-why.md}}

## セットアップ (最短)

```sh
{{インストールコマンド}}
{{バージョン確認コマンド}}
```

詳細は [docs/01-setup.md](./docs/01-setup.md)。

## 学習ロードマップ

| 章 | ドキュメント | サンプル | 学ぶこと |
|---|---|---|---|
| 0 | [00-why.md](./docs/00-why.md) | — | 位置づけ、向く用途 |
| 1 | [01-setup.md](./docs/01-setup.md) | — | インストール、バージョン固定 |
| 2 | [02-hello-world.md](./docs/02-hello-world.md) | [01-hello-world](./examples/01-hello-world/) | 最小プログラムとビルド |
| 3 | [03-basics.md](./docs/03-basics.md) | [02-basics](./examples/02-basics/) | 変数・関数・制御構造 |
| 4 | [04-data.md](./docs/04-data.md) | [03-data](./examples/03-data/) | データ構造・パターンマッチ |
| 5 | [05-core.md](./docs/05-core.md) | [04-core](./examples/04-core/) | {{目玉概念}} |
| 6 | [06-project.md](./docs/06-project.md) | [05-project](./examples/05-project/) | パッケージ管理・テスト |
| 99 | [99-resources.md](./docs/99-resources.md) | — | 公式資料・記事 |

## 検証

```sh
../scripts/check-{{lang}}.sh
```

## バージョン

{{.tool-versions / lean-toolchain / rust-toolchain.toml などの説明}}
