# MoonBit

> WASM ファーストで設計された、関数型寄りの汎用言語。Rust 風の構文に OCaml 系の型推論、テストとフォーマッタを同梱したツールチェイン。

## なぜ今学ぶのか

- **WASM (wasm-gc) と JS の両方にコンパイル**でき、生成物が小さい。ブラウザ・エッジ・プラグイン基盤の実装言語として伸びている。
- `test { }` ブロックがソースに直接書け、`moon test` ですぐ回る。スナップショットテストも標準。
- パターンマッチ、`enum` / `struct`、trait と、モダン言語の「良いところ」が最初から揃っている。

## セットアップ (最短)

```sh
curl -fsSL https://cli.moonbitlang.com/install/unix.sh | bash
moon version --all
```

## 章 5 (目玉概念) で扱うこと

- `test { }` ブロックと `moon test`
- `--target wasm-gc` / `--target js` でのビルドとブラウザからの呼び出し
- `moon.mod.json` / `moon.pkg.json` の役割

## 学習ロードマップ

| 章 | ドキュメント | サンプル | 学ぶこと |
|---|---|---|---|
| 0 | docs/00-why.md | — | 位置づけ、向く用途 |
| 1 | docs/01-setup.md | — | インストール、バージョン固定 |
| 2 | docs/02-hello-world.md | examples/01-hello-world | 最小プログラムとビルド |
| 3 | docs/03-basics.md | examples/02-basics | 変数・関数・制御構造 |
| 4 | docs/04-data.md | examples/03-data | データ構造・パターンマッチ |
| 5 | docs/05-core.md | examples/04-core | **WASM / JS バックエンドとインラインテスト** |
| 6 | docs/06-project.md | examples/05-project | パッケージ管理・テスト |
| 99 | docs/99-resources.md | — | 公式資料・記事 |

(ドキュメントとサンプルは Phase 1 以降で順次追加。設計は [DESIGN.md](../DESIGN.md) 参照)

## 検証 (Phase 2)

```sh
../scripts/check-moonbit.sh   # 各 example で moon check && moon test
```

## バージョン固定

`.tool-versions` に `moon version` の出力 (ツールチェインの日付) を記録する。
