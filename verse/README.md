# Verse

> Epic Games が UEFN (Unreal Editor for Fortnite) 向けに設計した関数論理型言語。「失敗」を第一級の概念として扱い、効果 (effect) を型で管理する。

## なぜ今学ぶのか

- `if` の条件が「失敗しうる式」であり、`<decides>` 関数・`for` の絞り込み・`<transacts>` のロールバックなど、他言語にない **failure context** の設計を体験できる。
- 効果システム (`<transacts>`, `<suspends>`, `<decides>`) が言語仕様に組み込まれており、Koka などの代数的効果を学ぶ入口にもなる。
- Fortnite という巨大な実行環境があり、書いたコードがすぐ「遊べる」。

## セットアップ (最短)

1. Epic Games Launcher から **UEFN** をインストール (Windows のみ)
2. UEFN で新規プロジェクト → Verse Explorer から Verse ファイルを追加
3. VS Code + Verse 拡張で編集

詳細と手順のスクリーンショットは docs/01-setup.md に載せる。

## 章 5 (目玉概念) で扱うこと

- `<decides>` 関数と失敗コンテキスト
- `for` による絞り込み、`option` 型
- `<transacts>` と失敗時ロールバック
- `Sleep` と `<suspends>` (非同期)

## CI について

Verse は UEFN 内でしか実行できないため **CI の対象外**。各 example の README に「UEFN x.y で動作確認 (日付)」を記す。
スタンドアロン処理系が公開された時点で CI 化を再検討する。

## 学習ロードマップ

| 章 | ドキュメント | サンプル | 学ぶこと |
|---|---|---|---|
| 0 | docs/00-why.md | — | 位置づけ、向く用途 |
| 1 | docs/01-setup.md | — | インストール、バージョン固定 |
| 2 | docs/02-hello-world.md | examples/01-hello-world | 最小プログラムとビルド |
| 3 | docs/03-basics.md | examples/02-basics | 変数・関数・制御構造 |
| 4 | docs/04-data.md | examples/03-data | データ構造・パターンマッチ |
| 5 | docs/05-core.md | examples/04-core | **failure context と効果システム** |
| 6 | docs/06-project.md | examples/05-project | パッケージ管理・テスト |
| 99 | docs/99-resources.md | — | 公式資料・記事 |

(ドキュメントとサンプルは Phase 1 以降で順次追加。設計は [DESIGN.md](../DESIGN.md) 参照)
