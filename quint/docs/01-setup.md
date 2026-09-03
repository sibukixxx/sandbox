# 01. セットアップ

## インストール

```sh
npm i -g @informalsystems/quint
```

Node.js 18 以上が必要。

## バージョン確認

```sh
quint --version    # 0.32.0
```

## Rust 評価器

`quint run` / `quint test` / REPL は、初回に Rust 製の評価器を GitHub Releases から自動取得する (`~/.quint/rust-evaluator-v<ver>/`)。

- 取得できない環境では `--backend=typescript` を付けると JS 実装で動く (遅いが結果は同じ)
- 手動で入れる場合: `https://github.com/informalsystems/quint/releases/download/evaluator%2Fv0.6.0/quint_evaluator-x86_64-unknown-linux-gnu.tar.gz` を展開して上記ディレクトリに置く

## モデル検査 (Apalache)

`quint verify` は Apalache (Java 製) を使う。Java 17 以上があれば初回に自動取得される。章 5 まで不要。

## バージョン固定

プロジェクトに `package.json` を置き、`devDependencies` に固定する。

```json
{ "devDependencies": { "@informalsystems/quint": "0.32.0" } }
```

## エディタ

VS Code 拡張「Quint」。型検査エラーとフォーマットがエディタで見える。

## 主なコマンド

| コマンド | 内容 |
|---|---|
| `quint typecheck f.qnt` | 型検査 |
| `quint run f.qnt --invariant=inv` | ランダムシミュレーション |
| `quint test f.qnt` | `run` 定義をテストとして実行 |
| `quint verify f.qnt --invariant=inv` | Apalache による網羅的検査 |
| `quint -r f.qnt::module` | REPL |
| `quint --main=M` | 複数モジュールのとき実行対象を指定 |

## 落とし穴

- `quint run` は既定でランダム探索なので、反例が見つからなくても「正しい」とは限らない。確証には `quint verify`。
- REPL への入力はモジュール内の名前をそのまま書く (`greeting`)。
