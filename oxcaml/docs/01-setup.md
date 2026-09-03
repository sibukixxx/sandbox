# 01. セットアップ

## インストール

opam (OCaml のパッケージマネージャ) が必要。

```sh
# opam
sh <(curl -sL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)
opam init

# OxCaml 用の switch を作る (コンパイラをビルドするので時間がかかる)
opam switch create 5.2.0+ox --repos ox=git+https://github.com/oxcaml/opam-repository.git,default
eval $(opam env --switch 5.2.0+ox --set-switch)

# ビルドツールと開発ツール
opam install dune ocaml-lsp-server ocamlformat
```

対応 OS は Linux (x86_64 / arm64) と macOS。Windows は未対応。

## バージョン確認

```sh
ocaml -version      # 5.2.0+ox のような表示
dune --version
```

## バージョン固定

- switch 名 (`5.2.0+ox`) を `README.md` に記載
- `oxcaml/opam-repository` のコミットハッシュを `.tool-versions` (作成予定) に記録する。OxCaml は活発に変化しているため、日付も併記する

## 標準 OCaml との使い分け

OxCaml の switch を使わずに標準 OCaml (`opam switch create 5.2.0`) で試すこともできる。
このリポジトリのサンプルは OxCaml 固有の構文をコメント内に隔離し、標準 OCaml でも動くようにしてある。

## エディタ

VS Code 拡張「OCaml Platform」+ `ocaml-lsp-server`。OxCaml 固有の構文も認識する (switch を切り替えて LSP を再起動する)。

## 主なコマンド

| コマンド | 内容 |
|---|---|
| `dune init proj <name>` | プロジェクト生成 |
| `dune build` | ビルド |
| `dune exec ./bin/main.exe` | 実行 |
| `dune test` | テスト |
| `dune fmt` | 整形 |
| `ocamlopt a.ml -o a` | dune なしで直接コンパイル |

## 落とし穴

- switch の作成には数十分かかる。CI では Docker イメージにキャッシュする (Phase 2)。
- `eval $(opam env)` を忘れると標準 OCaml のままになる。`ocaml -version` で `+ox` を確認する。
