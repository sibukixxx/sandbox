# 01. セットアップ

## インストール

```sh
curl -fsSL https://cli.moonbitlang.com/install/unix.sh | bash
# Windows: irm https://cli.moonbitlang.com/install/powershell.ps1 | iex
```

`~/.moon/bin` に `moon` (ビルドツール)、`moonc` (コンパイラ)、`moonrun` (WASM ランナー) が入る。PATH に追加する。

## バージョン確認

```sh
moon version --all
```

```
moon 0.1.20260827 (d0aaa07 2026-08-27)
moonc v0.10.11+6ff76a5f9 (2026-08-28)
moonrun 0.1.20260827 (d0aaa07 2026-08-27)
```

## バージョン固定

MoonBit は日付ベースでリリースされ、`moon update` / `moon upgrade` で最新になる。
このリポジトリでは `.tool-versions` に `moon version --all` の出力を記録し、動作確認した版を残す。
特定の版に戻すには `curl ... | bash -s <version>` を使う。

## 標準ライブラリ

`moon` のインストールで `core` も入る (`~/.moon/lib/core`)。`moon update` で更新。

## エディタ

VS Code 拡張「MoonBit Language」。LSP、フォーマッタ (`moon fmt`)、テストの実行がエディタからできる。

## 主なコマンド

| コマンド | 内容 |
|---|---|
| `moon new <name>` | プロジェクト生成 |
| `moon check` | 型検査のみ |
| `moon build` | ビルド |
| `moon run <pkg>` | 実行 (`--target wasm-gc / js / native`) |
| `moon test` | `test { }` ブロックを実行 (`--update` でスナップショット更新) |
| `moon fmt` | 整形 |
| `moon add <mod>` | 依存追加 (mooncakes.io) |

## 落とし穴

- 設定ファイルは `moon.mod` / `moon.pkg`。2025 年以前の記事の `moon.mod.json` / `moon.pkg.json` とは形式が違う。
- `moon run` にはパッケージのディレクトリを渡す。ファイルパスではない。
