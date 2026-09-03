# 01. セットアップ

## 必要なもの

- Windows 10/11 (UEFN は Windows 専用)
- Epic Games アカウントと Epic Games Launcher
- ある程度の GPU (Unreal Engine が動く環境)

## インストール

1. Epic Games Launcher を入れる
2. Launcher の「Unreal Engine」タブから **Unreal Editor for Fortnite (UEFN)** をインストール
3. Fortnite 本体もインストールしておく (セッションの起動に使う)

## プロジェクトの作成

1. UEFN を起動 → 新規プロジェクト → テンプレート「Blank」など
2. メニュー **Verse → Verse Explorer** を開く
3. プロジェクトを右クリック → **Add new Verse file to project** → 「Verse Device」テンプレートを選ぶ
4. 生成された `.verse` ファイルを VS Code で開く (UEFN が VS Code を起動する)

## ビルドと実行

| 操作 | 方法 |
|---|---|
| ビルド | UEFN で **Build Verse Code** (Ctrl+Shift+B) |
| 配置 | Content Browser に現れたデバイスをレベルにドラッグ |
| 実行 | **Launch Session** で Fortnite が起動し、島が動く |
| 出力 | UEFN の **Output Log** に `Print` の内容が出る |

## エディタ

VS Code + 拡張「Verse」(UEFN が自動で導入する)。補完・エラー表示・定義ジャンプが効く。

## バージョン固定

UEFN はアップデートが自動で、特定版に固定できない。動作確認したときは UEFN のバージョン (Help → About) と日付をサンプルの README に記録する。

## このリポジトリでの扱い

Linux の CI では実行できないため、サンプルは「UEFN で確認済み」の記録を README に残す運用にする。
`.verse` ファイルをそのまま UEFN プロジェクトの Verse フォルダにコピーすれば動く構成にしてある。

## 落とし穴

- インデントはスペース 4 つ。タブは不可。
- ファイル名と `class` 名は一致しなくてよいが、1 デバイス 1 ファイルにすると管理しやすい。
- Verse のドキュメントは https://dev.epicgames.com/documentation/en-us/uefn/verse-language-reference が正。
