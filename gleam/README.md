# Gleam

> BEAM (Erlang VM) 上で動く、静的型付きの関数型言語。Erlang / Elixir の並行性と耐障害性 (OTP) を、型安全に書ける。JavaScript にもコンパイルできる。

## なぜ今学ぶのか

- **OTP を型付きで**: Erlang のアクター (プロセス + メッセージ) は動的型だが、Gleam は `Subject(msg)` でメッセージの型を保証する。分散・並行システムの実績ある基盤を、型の助けを借りて学べる。
- **小さく一貫した言語**: `if` も `while` も例外もない。`case` 式、`Result`、`use` 構文だけで書く。学ぶことが少なく、読みやすい。
- **2 つのターゲット**: 同じコードが Erlang と JavaScript で動く。サーバは BEAM、フロントは JS、という構成が 1 言語で組める。
- **エラーメッセージとツールチェインの質**: `gleam` コマンド 1 つでビルド・テスト・整形・依存管理 (Hex)・ドキュメント生成。

## セットアップ (最短)

```sh
# Erlang/OTP 27 以上が必要 (apt の 25 では Gleam 1.18 の生成コードが動かない)
curl -fsSL https://github.com/gleam-lang/gleam/releases/download/v1.18.0/gleam-v1.18.0-x86_64-unknown-linux-musl.tar.gz | tar -xz
export PATH=$PWD:$PATH
gleam --version
```

## 章 5 (目玉概念) で扱うこと

- `gleam_otp` の actor: 状態 + メッセージハンドラ
- `process.send` / `process.call` と返信用 `Subject`
- `process.spawn` / `process.receive` による並列計算

## 学習ロードマップ

| 章 | ドキュメント | サンプル | 学ぶこと |
|---|---|---|---|
| 0 | [docs/00-why.md](./docs/00-why.md) | — | 位置づけ、向く用途 |
| 1 | [docs/01-setup.md](./docs/01-setup.md) | — | インストール、バージョン固定 |
| 2 | [docs/02-hello-world.md](./docs/02-hello-world.md) | [examples/01-hello-world](./examples/01-hello-world/) | 最小プログラムとビルド |
| 3 | [docs/03-basics.md](./docs/03-basics.md) | [examples/02-basics](./examples/02-basics/) | 条件分岐を関数として書く |
| 4 | [docs/04-data.md](./docs/04-data.md) | [examples/03-data](./examples/03-data/) | データ構造・パターンマッチ |
| 5 | [docs/05-core.md](./docs/05-core.md) | [examples/04-core](./examples/04-core/) | **OTP アクターと型安全な並行処理** |
| 6 | [docs/06-modules.md](./docs/06-modules.md) | [examples/05-modules](./examples/05-modules/) | モジュールの扱い |
| 99 | [docs/99-resources.md](./docs/99-resources.md) | — | 公式資料・記事 |

## 検証

```sh
../scripts/check-gleam.sh
```

## バージョン固定

`.tool-versions` に `gleam 1.18.0` と `erlang 27.3`。各 example の `manifest.toml` が依存パッケージのロックファイル。
