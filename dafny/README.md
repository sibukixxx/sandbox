# Dafny

> 事前条件・事後条件・ループ不変条件をコードに書き、コンパイラ (Z3) がそれを **自動証明** する検証指向言語。検証済みコードを C# / Go / Python / JS / Java に出力できる。

## なぜ今学ぶのか

- Lean より低い学習コストで「証明された正しさ」を体験できる。`requires` / `ensures` を書くだけで、コンパイラが反例を指摘する。
- AWS などが実運用で使っており、「検証しながら書く」スタイルが実務でも通じる。
- 証明が通らないときにどう不変条件を直すか、という思考は他言語でのテスト設計にも直結する。

## セットアップ (最短)

```sh
dotnet tool install -g dafny    # または GitHub Releases のバイナリ (Z3 同梱)
dafny --version
```

## 章 5 (目玉概念) で扱うこと

- `requires` / `ensures` / `invariant` / `decreases`
- `lemma` と `assert` で証明を助ける
- 題材: 絶対値 → 二分探索 → 挿入ソート

## 学習ロードマップ

| 章 | ドキュメント | サンプル | 学ぶこと |
|---|---|---|---|
| 0 | docs/00-why.md | — | 位置づけ、向く用途 |
| 1 | docs/01-setup.md | — | インストール、バージョン固定 |
| 2 | docs/02-hello-world.md | examples/01-hello-world | 最小プログラムとビルド |
| 3 | docs/03-basics.md | examples/02-basics | 変数・関数・制御構造 |
| 4 | docs/04-data.md | examples/03-data | データ構造・パターンマッチ |
| 5 | docs/05-core.md | examples/04-core | **事前条件・事後条件・ループ不変条件で証明する** |
| 6 | docs/06-project.md | examples/05-project | パッケージ管理・テスト |
| 99 | docs/99-resources.md | — | 公式資料・記事 |

(ドキュメントとサンプルは Phase 1 以降で順次追加。設計は [DESIGN.md](../DESIGN.md) 参照)

## 検証 (Phase 2)

```sh
../scripts/check-dafny.sh   # dafny verify + dafny run で期待出力と diff
```

## バージョン固定

`.tool-versions` にバージョン番号。
