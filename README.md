# Programming Languages Sandbox

実験的なプログラミング言語の学習・比較リポジトリ。各言語をドキュメント + 実行可能なサンプルコードで扱っています。

## 言語

- MoonBit (WASM-first 関数型言語)
- OxCaml (Jane Street 製 OCaml 拡張)
- Lean 4 (定理証明器兼関数型言語)
- Quint (分散システム仕様記述言語)
- Verse (Epic/UEFN 関数論理型言語)
- Dafny (検証指向言語)
- Rust no_std (標準ライブラリなし Rust)

## 構成

| # | ディレクトリ | 言語 | 一言で | 差がつくポイント |
|---|---|---|---|---|
| 1 | [`moonbit/`](./moonbit/) | MoonBit | WASM ファーストの関数型寄り汎用言語 | WASM/JS 両バックエンド、組み込みテスト |
| 2 | [`oxcaml/`](./oxcaml/) | OxCaml | Jane Street 製 OCaml 拡張 | モード (local/unique/once)、unboxed 型 |
| 3 | [`lean/`](./lean/) | Lean 4 | 定理証明器 兼 関数型言語 | 依存型、証明とプログラムの統合 |
| 4 | [`quint/`](./quint/) | Quint | TLA+ 系の仕様記述言語 | 分散システム設計をシミュレーション・モデル検査 |
| 5 | [`verse/`](./verse/) | Verse | Epic (UEFN) の関数論理型言語 | failure context、トランザクション、効果システム |
| 6 | [`dafny/`](./dafny/) | Dafny | 検証指向言語 | 事前/事後条件をコンパイラが証明 |
| 7 | [`rust-no-std/`](./rust-no-std/) | Rust (`no_std`) | 標準ライブラリなし Rust | ベアメタル・組込み・カーネル空間 |
| 8 | [`zig/`](./zig/) | Zig | C の後継を狙うシステム言語 | comptime、明示的アロケータ、クロスコンパイル |
| 9 | [`gleam/`](./gleam/) | Gleam | BEAM 上の静的型付き関数型言語 | 型付き OTP アクター、Erlang / JS 両ターゲット |
| 10 | [`koka/`](./koka/) | Koka | 効果システムを中心にした関数型言語 | 代数的効果とハンドラ、効果型 |

各言語ディレクトリ (`<lang>/`) は：
- `docs/` - ドキュメント (なぜ学ぶか、セットアップ、基本機能)
- `examples/` - 実行可能なサンプルコード

`comparison/` ディレクトリでは同じテーマを複数言語で横断比較しています。

| ファイル | 内容 |
|---|---|
| [comparison/00-overview.md](./comparison/00-overview.md) | 10 言語の一覧表 (系統・型・実行環境・ツール・目玉機能・学習コスト) とテーマ別マップ |
| [comparison/02-hello-world.md](./comparison/02-hello-world.md) | Hello World の横断比較 |
| [comparison/03-conditionals.md](./comparison/03-conditionals.md) | 条件分岐を関数として書く、の横断比較 |
| [comparison/04-data.md](./comparison/04-data.md) | データ構造の横断比較 |
| [comparison/05-core.md](./comparison/05-core.md) | 各言語の目玉概念の横断比較 |
| [comparison/06-modules.md](./comparison/06-modules.md) | モジュールの扱いの横断比較 |
| [comparison/_article-template.md](./comparison/_article-template.md) | 記事の雛形 |

## テーマから選ぶ

| テーマ | 言語 |
|---|---|
| 形式検証・証明 | Lean, Dafny, Quint |
| 型システムの先端 | OxCaml, Lean, Verse, Koka |
| 効果システム | Koka, Verse |
| 低レイヤ・性能 | Rust no_std, Zig, OxCaml, MoonBit (WASM) |
| 並行・分散 | Gleam (BEAM), Quint (設計検証) |
| 新しい実行環境 | MoonBit (WASM/JS), Verse (UEFN), Rust no_std (組込み), Gleam (BEAM/JS) |

## 各言語ディレクトリの読み方

```
<lang>/
├── README.md          # 概要・なぜ学ぶか・セットアップ・学習ロードマップ
├── docs/              # 00-why → 01-setup → 02-hello-world → ... → 99-resources の順に読む
│   ├── 02-hello-world.md
│   ├── 03-basics.md   # 条件分岐を関数として書く
│   ├── 04-data.md     # データ構造
│   ├── 05-core.md     # その言語の目玉概念
│   └── 06-modules.md  # モジュールの扱い
└── examples/          # docs の章に対応する実行可能サンプル
    ├── 01-hello-world/
    ├── 02-basics/
    ├── 03-data/
    ├── 04-core/
    └── 05-modules/
```

- `docs/NN-*.md` を読んだら `examples/(NN-1)-*/` を動かす、を繰り返します。
- 各 example の `README.md` に実行コマンドと期待出力があります。

## 進捗

| 言語 | 00 なぜ | 01 設定 | 02 Hello World | 03 条件分岐 | 04 データ | 05 目玉概念 | 06 モジュール | 99 資料 | check スクリプト |
|---|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
| MoonBit | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| OxCaml | ✅ | ✅ | ✅ | ✅ | ✅ | 📝 | ✅ | ✅ | ✅ (標準 OCaml で 04-core 以外) |
| Lean 4 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Quint | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Verse | ✅ | ✅ | 📝 | 📝 | 📝 | 📝 | 📝 | ✅ | 対象外 |
| Dafny | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Rust no_std | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Zig | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Gleam | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Koka | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |

✅ = ドキュメント + サンプルあり、ローカルで動作確認済み / 📝 = 記述のみ (Verse は UEFN、OxCaml 第 5 章は OxCaml switch での動作未確認)

## 検証する

```sh
./scripts/check-all.sh            # 全言語 (Verse を除く 9 言語)
./scripts/check-lean.sh           # 1 言語だけ
DAFNY=/path/to/dafny ./scripts/check-dafny.sh   # バイナリの場所を指定
KOKA=/path/to/koka ./scripts/check-koka.sh
```

詳細は [DESIGN.md](./DESIGN.md) を参照してください。
