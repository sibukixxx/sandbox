# 今学んでおくと差がつくプログラミング言語10選

「今学んでおくと差がつく」言語を 1 言語 1 ディレクトリで扱い、
**ハローワールドから基本的な使い方まで** をドキュメントと実行できるサンプルコードで残す学習リポジトリです。

設計方針・進め方は [DESIGN.md](./DESIGN.md) を参照してください。

## 言語一覧

| # | ディレクトリ | 言語 | 一言で | 差がつくポイント |
|---|---|---|---|---|
| 1 | [`moonbit/`](./moonbit/) | MoonBit | WASM ファーストの関数型寄り汎用言語 | WASM/JS 両バックエンド、組み込みテスト |
| 2 | [`oxcaml/`](./oxcaml/) | OxCaml | Jane Street 製 OCaml 拡張 | モード (local/unique/once)、unboxed 型 |
| 3 | [`lean/`](./lean/) | Lean 4 | 定理証明器 兼 関数型言語 | 依存型、証明とプログラムの統合 |
| 4 | [`quint/`](./quint/) | Quint | TLA+ 系の仕様記述言語 | 分散システム設計をシミュレーション・モデル検査 |
| 5 | [`verse/`](./verse/) | Verse | Epic (UEFN) の関数論理型言語 | failure context、トランザクション、効果システム |
| 6 | [`dafny/`](./dafny/) | Dafny | 検証指向言語 | 事前/事後条件をコンパイラが証明 |
| 7 | [`rust-no-std/`](./rust-no-std/) | Rust (`no_std`) | 標準ライブラリなし Rust | ベアメタル・組込み・カーネル空間 |
| 8〜10 | 未定 | — | — | 候補は [DESIGN.md §9](./DESIGN.md#9-残り-3-枠の候補) |

## 言語横断で比較する (ブログ・比較サイト用)

同じテーマを 7 言語横並びで見たいときは [`comparison/`](./comparison/) を読む。記事の下書きにそのまま使える構成になっている。

| ファイル | 内容 |
|---|---|
| [comparison/00-overview.md](./comparison/00-overview.md) | 7 言語の一覧表 (系統・型・実行環境・ツール・目玉機能・学習コスト) とテーマ別マップ |
| [comparison/02-hello-world.md](./comparison/02-hello-world.md) | Hello World の横断比較 |
| [comparison/03-conditionals.md](./comparison/03-conditionals.md) | 条件分岐を関数として書く、の横断比較 |
| [comparison/06-modules.md](./comparison/06-modules.md) | モジュールの扱いの横断比較 |
| [comparison/_article-template.md](./comparison/_article-template.md) | 記事の雛形 |

## テーマから選ぶ

| テーマ | 言語 |
|---|---|
| 形式検証・証明 | Lean, Dafny, Quint |
| 型システムの先端 | OxCaml, Lean, Verse |
| 低レイヤ・性能 | Rust no_std, OxCaml, MoonBit (WASM) |
| 新しい実行環境 | MoonBit (WASM/JS), Verse (UEFN), Rust no_std (組込み) |

## 各言語ディレクトリの読み方

```
<lang>/
├── README.md          # 概要・なぜ学ぶか・セットアップ・学習ロードマップ
├── docs/              # 00-why → 01-setup → 02-hello-world → ... → 99-resources の順に読む
│   ├── 02-hello-world.md
│   ├── 03-basics.md   # 条件分岐を関数として書く
│   └── 06-modules.md  # モジュールの扱い
└── examples/          # docs の章に対応する実行可能サンプル
    ├── 01-hello-world/
    ├── 02-basics/
    └── 05-modules/
```

- `docs/NN-*.md` を読んだら `examples/(NN-1)-*/` を動かす、を繰り返します。
- 各 example の `README.md` に実行コマンドと期待出力があります。

## 進捗

| 言語 | 設計 | 02 Hello World | 03 条件分岐 | 04 データ | 05 目玉概念 | 06 モジュール | CI |
|---|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
| MoonBit | ✅ | ✅ | ✅ | | | ✅ | |
| OxCaml | ✅ | ✅ | ✅ | | | ✅ | |
| Lean 4 | ✅ | ✅ | ✅ | | | ✅ | |
| Quint | ✅ | ✅ | ✅ | | | ✅ | |
| Verse | ✅ | 📝 | 📝 | | | 📝 | 対象外 |
| Dafny | ✅ | ✅ | ✅ | | | ✅ | |
| Rust no_std | ✅ | ✅ | ✅ | | | ✅ | |

✅ = ドキュメント + サンプルあり、ローカルで動作確認済み / 📝 = 記述のみ (UEFN での動作未確認)

## 新しい言語を追加する

`_template/` をコピーして始めます。手順は [DESIGN.md §10](./DESIGN.md#10-追加時の手順_template-の使い方) を参照。
