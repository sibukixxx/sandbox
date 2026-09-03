# 設計書: 今学んでおくと差がつくプログラミング言語10選 学習リポジトリ

## 1. 目的

「今学んでおくと差がつく」言語を 1 言語 1 ディレクトリで扱い、
**ハローワールドから基本的な使い方まで** を次の 2 つの形で残す。

1. **ドキュメント** (`docs/`) — 日本語の解説。読めば概念が分かる。
2. **サンプルコード** (`examples/`) — 実際にビルド・実行・検証できるコード。
3. **言語横断比較** (`comparison/`) — 同じテーマを 7 言語横並びで。学習ブログ・比較サイトの記事の下書きになる。

ドキュメントとサンプルは章番号で 1:1 に対応させ、「読む → 動かす」を往復できるようにする。
比較ドキュメントも同じ章番号を使い、`comparison/03-*.md` は各言語の `docs/03-*.md` を横に並べたものにする。

## 2. 対象言語

| # | ディレクトリ | 言語 | 一言で | 差がつくポイント |
|---|---|---|---|---|
| 1 | `moonbit/` | MoonBit | WASM ファーストの関数型寄り汎用言語 | WASM/JS 両バックエンド、組み込みテスト、AI 時代のツールチェイン |
| 2 | `oxcaml/` | OxCaml | Jane Street 製 OCaml 拡張 | モード（local/unique/once）、unboxed 型による GC なし高速化 |
| 3 | `lean/` | Lean 4 | 定理証明器 兼 関数型言語 | 依存型、`#eval`、Mathlib、証明とプログラムの統合 |
| 4 | `quint/` | Quint | TLA+ 系の仕様記述言語 | 分散システム設計を実行・シミュレーション・モデル検査できる |
| 5 | `verse/` | Verse | Epic (UEFN) の関数論理型言語 | failure context、トランザクション、効果システム |
| 6 | `dafny/` | Dafny | 検証指向言語 | 事前/事後条件・ループ不変条件をコンパイラが証明する |
| 7 | `rust-no-std/` | Rust (`no_std`) | 標準ライブラリなし Rust | ベアメタル・組込み・WASM・カーネル空間での Rust |
| 8 | (未定) | — | — | 候補は §9 参照 |
| 9 | (未定) | — | — | 候補は §9 参照 |
| 10 | (未定) | — | — | 候補は §9 参照 |

7 言語が確定済み。残り 3 枠は §9 の候補から選ぶ。

### 2.1 テーマ横断マップ

言語を「何が学べるか」で並べ替えると、リポジトリ全体で次の 4 テーマを網羅する。

| テーマ | 言語 |
|---|---|
| 形式検証・証明 | Lean, Dafny, Quint |
| 型システムの先端 | OxCaml, Lean, Verse |
| 低レイヤ・性能 | Rust no_std, OxCaml, MoonBit(WASM) |
| 新しい実行環境 | MoonBit(WASM/JS), Verse(UEFN), Rust no_std(組込み) |

トップ README ではこの表を掲載し、読者が興味のテーマから入れるようにする。

## 3. ディレクトリ構成

```
.
├── README.md                # 全体の入口。言語一覧・テーママップ・使い方
├── DESIGN.md                # 本設計書
├── _template/               # 新しい言語を追加するときの雛形
│   ├── README.md
│   ├── docs/
│   └── examples/
├── comparison/              # 言語横断比較 (ブログ・比較サイト用素材)
│   ├── README.md            # 使い方、比較の軸、題材の統一ルール
│   ├── _article-template.md # 記事の雛形
│   ├── 00-overview.md       # 7 言語の一覧表、テーマ別マップ
│   ├── 02-hello-world.md    # 章番号は docs/ と揃える
│   ├── 03-conditionals.md
│   ├── 04-data.md
│   ├── 05-core.md
│   └── 06-modules.md
├── moonbit/
├── oxcaml/
├── lean/
├── quint/
├── verse/
├── dafny/
├── rust-no-std/
├── scripts/                 # 各言語のセットアップ・検証スクリプト (Phase 2)
│   ├── setup-<lang>.sh
│   └── check-<lang>.sh
└── .github/workflows/       # CI (Phase 2)
    └── ci.yml
```

### 3.1 各言語ディレクトリの共通構成

```
<lang>/
├── README.md                # 言語概要・なぜ学ぶか・セットアップ・学習ロードマップ(章一覧)
├── docs/
│   ├── 00-why.md            # なぜ今学ぶのか。位置づけ、向く用途、向かない用途
│   ├── 01-setup.md          # インストール、バージョン固定、エディタ設定
│   ├── 02-hello-world.md    # 最小プログラム、ビルド、実行、ファイル構成の意味
│   ├── 03-basics.md         # 変数・関数・制御構造・基本型
│   ├── 04-data.md           # データ構造、パターンマッチ、コレクション
│   ├── 05-core.md           # その言語の「目玉」概念 (言語ごとにタイトルを変える)
│   ├── 06-modules.md        # モジュール、パッケージ管理、複数ファイル、テスト
│   └── 99-resources.md      # 公式ドキュメント、良い記事、コミュニティ
├── examples/
│   ├── 01-hello-world/      # docs/02 に対応
│   ├── 02-basics/           # docs/03 に対応
│   ├── 03-data/             # docs/04 に対応
│   ├── 04-core/             # docs/05 に対応
│   └── 05-modules/          # docs/06 に対応 (複数モジュール構成の小プロジェクト)
└── .tool-versions           # 言語・ツールのバージョン固定 (言語ごとに形式は変えてよい)
```

- `docs/NN-*.md` と `examples/MM-*/` の対応は **docs の番号 = examples の番号 + 1**。
  docs の 00/01 はコードを伴わないため、examples は 01 から始まる。
- 章の粒度は「1 章 = 30〜60 分で読んで動かせる」を目安にする。
- `05-core.md` のタイトルは言語ごとに具体化する（§5 参照）。

### 3.2 examples の各ディレクトリの規約

- 必ず **その言語の標準的なプロジェクト形式** で作る（`moon.mod.json`, `lakefile.lean`, `Cargo.toml` など）。
  単発ファイルで済む言語 (Quint, Dafny, Verse) は 1 ファイル + `README.md`。
- 各ディレクトリ直下に `README.md` を置き、以下を必ず書く。
  - このサンプルで学ぶこと（3 行以内）
  - 実行コマンド（コピペで動く）
  - 期待される出力
- 実行可能な言語では **テストまたは検証コマンドが通る状態** を維持する（§7 CI）。

## 4. ドキュメントの書き方

- 言語は日本語。識別子・コマンド・公式用語は英語のまま。
- 各章は「目的 → 最小コード → 解説 → 落とし穴 → 演習 (任意)」の順で書く。
- コードブロックには必ず言語識別子をつける（`moonbit`, `ocaml`, `lean`, `quint`, `verse`, `dafny`, `rust`）。
- **「他の言語ではこう書く」比較** を各章に 1 つ以上入れる。差がつく理由を実感させるため。
- 検証系言語（Lean, Dafny, Quint）では **失敗する例** も必ず載せ、エラーメッセージの読み方を書く。

### 3.3 `comparison/` の規約 (ブログ・比較サイト向け)

- ファイル名は `NN-<theme>.md` で、`NN` は各言語の `docs/NN-*.md` と同じ章番号にする。
- 構成は固定: **一覧表 → 言語ごとのコード (examples へのリンク付き) → 違いの考察 → どれを選ぶか**。
  記事にするときはこの順のまま使える。雛形は `comparison/_article-template.md`。
- 題材は全言語で統一する (`sign`, `fizzbuzz`, `Shape`, `checkedDiv`, `Meters`)。新しいテーマを足すときも 1 つの題材を決めてから書く。
- コードは `examples/` のものを短縮して載せ、必ずリンクで元を指す。動作未確認の言語 (Verse) は表と本文の両方に明記する。
- 一覧表の ✅ / ❌ は「自然に書ける / 回り道が要る」の意味。

## 5. 言語別の設計

### 5.1 MoonBit (`moonbit/`)

- ツールチェイン: `moon` CLI (`curl -fsSL https://cli.moonbitlang.com/install/unix.sh | bash`)
- `05-core.md` = **WASM / JS バックエンドとインラインテスト**
- 章の要点:
  - 02: `moon new` の生成物 (`moon.mod.json`, `moon.pkg.json`, `main.mbt`)、`moon run`
  - 03: `let` / `fn` / `if` / `match` / 整数と文字列
  - 04: `enum` / `struct` / `Array` / `Map` / `Option` / `Result`
  - 05: `test { }` ブロック、`moon test`、`--target wasm-gc` / `--target js`、ブラウザから呼ぶ
  - 06: パッケージ分割、`pub` の可視性、`moon check`、`moon fmt`
- CI: Linux で `moon` をインストールし `moon check && moon test` を全 examples で実行。

### 5.2 OxCaml (`oxcaml/`)

- ツールチェイン: `opam` + OxCaml 専用 switch (`opam switch create 5.2.0+ox --repos ox=git+https://github.com/oxcaml/opam-repository.git`)
- `05-core.md` = **モード (local / unique / once) と unboxed 型**
- 章の要点:
  - 02: `dune init`、`dune build`、`dune exec`、通常 OCaml との差分なしで動くことを確認
  - 03: 標準 OCaml の復習（`let`, 再帰, パイプ）。OCaml 未経験者向けに簡潔に
  - 04: バリアント、レコード、モジュール
  - 05: `local_` でスタック割り当て、`unique_` による所有権、`float#` などの unboxed 型、`[@zero_alloc]`
  - 06: dune プロジェクト、`ppx_expect` テスト、標準 OCaml との互換性の保ち方
- CI: opam の switch 作成に時間がかかるため **Docker イメージをキャッシュ** して使う。
- 注意: OxCaml は活発に変化中。`.tool-versions` にコミットハッシュまたは日付を残す。

### 5.3 Lean 4 (`lean/`)

- ツールチェイン: `elan` (`curl https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh -sSf | sh`) + `lake`
- `05-core.md` = **命題と証明（tactic 入門）**
- 章の要点:
  - 02: `lake new`、`#eval`、`lake build && lake exe`
  - 03: `def` / `structure` / `inductive` / パターンマッチ / `do` 記法
  - 04: `List` / `Array` / `Option` / 型クラス (`ToString`, `Inhabited`)
  - 05: `theorem`、`by simp` / `intro` / `induction` / `rfl`、失敗する証明の読み方、`decide`
  - 06: `lakefile.lean`、Mathlib 依存追加、`lake test`、VS Code 拡張の使い方
- CI: `elan` インストール + `lake build`。Mathlib を使う章は CI では `--no-mathlib` 相当の分離を検討（ビルド時間が長いため）。

### 5.4 Quint (`quint/`)

- ツールチェイン: `npm i -g @informalsystems/quint`（Apalache モデル検査は Java 依存、任意）
- `05-core.md` = **状態機械のシミュレーションと不変条件の検査**
- 章の要点:
  - 02: `module`、`pure def`、`quint repl`、`quint typecheck`
  - 03: 型（`int`, `str`, `bool`, `Set`, `List`, `Map`）、`pure def`、演算子
  - 04: レコード、和型、`Set` 内包表記、`Map` 更新
  - 05: `var` / `action` / `init` / `step`、`quint run --invariant`、反例トレースの読み方
  - 06: 複数モジュール、`quint verify`（Apalache）、TLA+ との対応表
- CI: Node で `quint typecheck` と `quint run` を全 spec に実行。`quint verify` は任意ジョブ。
- 題材: 銀行口座 → 二相コミット → 簡易 Raft リーダー選出、と段階的に。

### 5.5 Verse (`verse/`)

- ツールチェイン: **UEFN (Unreal Editor for Fortnite)**。Windows 専用で Linux CI では実行不可。
- `05-core.md` = **failure context と効果システム (`<decides>`, `<transacts>`, `<suspends>`)**
- 章の要点:
  - 01: UEFN のインストール、Verse プロジェクトの作り方、VS Code 拡張
  - 02: `creative_device` を継承した最小デバイス、`Print`、Fortnite 内で動かす手順（スクショ付き）
  - 03: `var` / `:=` / `set` / 関数定義、`if` が失敗コンテキスト
  - 04: `class` / `interface` / `array` / `map` / `option`
  - 05: `<decides>` 関数、`for` の失敗による絞り込み、`<transacts>` のロールバック、`Sleep` と `<suspends>`
  - 06: 複数ファイル、モジュール、UEFN のデバイス連携
- CI: **実行検証は対象外**。代わりにレビュー時に UEFN で動作確認した旨を `examples/*/README.md` に日付付きで記す。
  Verse のオープンソース化・スタンドアロン処理系が公開された時点で CI 化を再検討する。

### 5.6 Dafny (`dafny/`)

- ツールチェイン: `dotnet tool install -g dafny` または GitHub Releases のバイナリ（Z3 同梱）
- `05-core.md` = **事前条件・事後条件・ループ不変条件で証明する**
- 章の要点:
  - 02: `method Main()`、`dafny run`、`dafny verify`、`dafny build --target:py` など
  - 03: `method` と `function` の違い、`var`、`if`、`while`
  - 04: `seq` / `set` / `map` / `datatype` / `class`
  - 05: `requires` / `ensures` / `invariant` / `decreases` / `lemma` / `assert`、検証失敗の直し方
  - 06: `include`、`module`、他言語へのコンパイルと呼び出し、`{:test}` 属性
- CI: Dafny バイナリを取得し `dafny verify` を全ファイルに実行。`dafny run` で出力比較。
- 題材: 絶対値 → 二分探索 → 挿入ソート、と検証の難易度を上げる。

### 5.7 Rust `no_std` (`rust-no-std/`)

- ツールチェイン: `rustup` + `nightly`（一部）+ ターゲット `thumbv7em-none-eabihf`, `x86_64-unknown-none`, `wasm32-unknown-unknown` + QEMU
- `05-core.md` = **`#![no_std]` / `#![no_main]` / `panic_handler` とベアメタル実行**
- 章の要点:
  - 02: `#![no_std]` ライブラリクレートを **ホスト上で `cargo test`** できる形で作る（最も簡単な入口）
  - 03: `core` にあるもの・ないもの、`alloc` と `GlobalAlloc`、`heapless`
  - 04: `Option`/`Result`/イテレータは `core` で使える、`core::fmt::Write` で出力
  - 05: `#![no_main]` バイナリ、`panic_handler`、リンカスクリプト、`x86_64-unknown-none` または Cortex-M + QEMU で `Hello` を出す
  - 06: `embedded-hal`、`cargo-embed`/`probe-rs`、`cfg(feature = "std")` による std/no_std 両対応クレート
- CI: `cargo build --target ...` と `cargo test`（ホスト側）。QEMU 実行は `qemu-system-arm` を apt で入れて実施。
- 前提: 通常の Rust は既知とし、std との差分に集中する。

## 6. バージョン固定方針

| 言語 | 固定方法 |
|---|---|
| MoonBit | `.tool-versions` にツールチェインの日付 (`moon version` の出力) |
| OxCaml | switch 名 + opam-repository のコミットハッシュ |
| Lean | `lean-toolchain` ファイル（elan 標準） |
| Quint | `package.json` の `devDependencies` |
| Verse | UEFN のバージョン番号を `README.md` に記載 |
| Dafny | `.tool-versions` にバージョン番号 |
| Rust | `rust-toolchain.toml` |

## 7. CI 設計 (Phase 2 で実装)

- GitHub Actions。言語ごとに独立ジョブ。`paths` フィルタで **変更された言語だけ** 走らせる。
- 各ジョブは `scripts/check-<lang>.sh` を呼ぶだけにし、ローカルでも同じスクリプトで検証できるようにする。
- 環境構築が重い言語 (OxCaml, Lean+Mathlib) は Docker イメージを GHCR にキャッシュ。
- Verse は CI 対象外（§5.5）。

| 言語 | check スクリプトの内容 |
|---|---|
| MoonBit | `moon check && moon test` を各 example で |
| OxCaml | `dune build && dune test` を各 example で |
| Lean | `lake build` (+ `lake test`) を各 example で |
| Quint | `quint typecheck` + `quint run --invariant` |
| Dafny | `dafny verify` + `dafny run` で期待出力と diff |
| Rust | `cargo test` (host) + `cargo build --target <target>` + QEMU 実行 |

### 5.8 動作確認の記録 (2026-09-02)

| 言語 | 確認したツールチェイン | 備考 |
|---|---|---|
| MoonBit | moon 0.1.20260827 | `moon.mod` / `moon.pkg` は新形式 (旧 JSON 形式ではない) |
| OxCaml | OCaml 4.14.1 (ocamlopt 直接) | dune / OxCaml switch は未確認 (コンパイラのソース取得がプロキシで 403)。第 5 章のみ OxCaml 固有構文を使い、未確認と明記 |
| Lean 4 | v4.33.1 | `lakefile.toml` 形式 |
| Quint | 0.32.0 + Rust 評価器 v0.6.0 | 評価器は GitHub Releases から手動取得 |
| Verse | 未確認 | UEFN が必要 |
| Dafny | 4.10.0 | 実行は `--target:js` (dotnet 不在のため)。`bignumber.js` が必要 |
| Rust | cargo 1.94.1 stable | `thumbv7em-none-eabihf` ビルド、`thumbv7m-none-eabi` + QEMU 実行も確認 |

## 8. 実装フェーズ

| Phase | 内容 | 完了条件 |
|---|---|---|
| 0 | 本設計、ディレクトリ骨組み、各言語 README | 完了 |
| 1 | 全言語の `docs/00〜02` + `examples/01-hello-world` | 完了 (Verse 以外は動作確認済み) |
| 1' | 全言語の `docs/03`, `06` + `examples/02-basics`, `05-modules` (条件分岐・モジュール) | 完了 (Verse 以外は動作確認済み) |
| 1'' | `comparison/` (一覧、Hello World、条件分岐、モジュールの横断比較) | 完了 |
| 2 | `scripts/` と CI | main へのマージで CI が緑 |
| 3 | `docs/03〜04` + `examples/02〜03` | 完了 (Verse 以外は動作確認済み)。`comparison/04-data.md` も作成 |
| 4 | `docs/05` + `examples/04` | 完了 (Verse と OxCaml は動作未確認)。`comparison/05-core.md` も作成 |
| 5 | `docs/06`, `99` + `examples/05` | モジュール構成の小プロジェクトで締める |
| 6 | 残り 3 言語の選定と Phase 1〜5 の繰り返し | 10 言語揃う |

各 Phase で `docs/NN` を全言語分書いたら、同じ番号の `comparison/NN-*.md` も書く。

Phase 1 は **1 言語 1 PR** で進め、`_template/` の使い勝手を早期に検証する。

## 9. 残り 3 枠の候補

| 候補 | 差がつく理由 | 近い既存言語 |
|---|---|---|
| Zig | C 置き換え、comptime、クロスコンパイル | Rust no_std |
| Mojo | Python 互換の高速言語、AI/ML 向け | — |
| Gleam | BEAM 上の静的型付け、Erlang/OTP を型安全に | — |
| Koka | 代数的効果 (algebraic effects) を言語機能として | Verse (効果) |
| Unison | コンテンツアドレス指定コード、分散計算 | — |
| Roc | 純粋関数型・プラットフォーム分離 | MoonBit |
| Idris 2 | 依存型 + 線形型を実用言語で | Lean, OxCaml |
| Bend / HVM | 並列評価を自動化する関数型 | — |

テーマの重複を避けるなら **Zig (低レイヤ)、Gleam (分散/BEAM)、Koka または Mojo** の組み合わせを推奨する。

## 10. 追加時の手順（`_template/` の使い方）

1. `cp -r _template <lang>`
2. `<lang>/README.md` の `{{...}}` を埋める
3. `docs/00-why.md`, `01-setup.md`, `02-hello-world.md`, `examples/01-hello-world/` を作る
4. `scripts/check-<lang>.sh` を作り、ローカルで通す
5. トップ `README.md` の一覧表と本書 §2 の表に行を追加する
