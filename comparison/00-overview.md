# 00. 7 言語の一覧

## 一覧表

| 言語 | 系統 | 型付け | 実行環境 | ツールチェイン | 目玉機能 | 学習コスト (目安) |
|---|---|---|---|---|---|---|
| MoonBit | ML 系 + Rust 風構文 | 静的・推論 | WASM (wasm-gc) / JS / ネイティブ | `moon` (ビルド・テスト・fmt 一体) | WASM ファースト、インラインテスト | 低。Rust / TS 経験者なら 1 日 |
| OxCaml | OCaml 拡張 | 静的・推論 + モード | ネイティブ | `opam` + `dune` | モード (local / unique)、unboxed 型、`[@zero_alloc]` | 中。OCaml + 所有権の概念 |
| Lean 4 | 依存型関数型 / 定理証明器 | 依存型 | ネイティブ (C 経由) | `elan` + `lake` | 証明とプログラムの統合、`#eval` | 高。証明 (tactic) に慣れが必要 |
| Quint | TLA+ 系仕様記述 | 静的・推論 | シミュレータ / モデル検査器 | `npm` (`quint`) + Apalache | 状態機械の実行と不変条件検査 | 中。プログラムではなく「仕様」を書く発想 |
| Verse | 関数論理型 | 静的 + 効果 | UEFN (Fortnite) | UEFN (Windows) | 失敗コンテキスト、効果システム | 中。UEFN の環境構築がハードル |
| Dafny | 検証指向 (C# 風) | 静的 | C# / Go / Python / JS / Java に出力 | `dafny` (Z3 同梱) | requires / ensures の自動証明 | 低〜中。仕様の書き方に慣れれば早い |
| Rust no_std | システム | 静的・所有権 | ベアメタル / 組込み / WASM | `cargo` + `rustup` target | std なしで OS レベルのコードを書く | 中。Rust 既習が前提 |

## テーマ別マップ

| 学びたいこと | 第 1 候補 | 第 2 候補 | 理由 |
|---|---|---|---|
| 「正しさを証明する」を体験したい | Dafny | Lean 4 | Dafny は `ensures` を書くだけで自動証明。Lean は自分で証明を書くので深いが重い |
| 分散システムの設計を検証したい | Quint | — | 状態機械 + 不変条件 + モデル検査が一体 |
| GC 言語のまま性能を追いたい | OxCaml | MoonBit | モードで割り当てを制御。MoonBit は WASM 出力が小さい |
| OS のない環境で動かしたい | Rust no_std | MoonBit (WASM) | ベアメタルは Rust 一択。WASM ランタイム上なら MoonBit も |
| 新しい言語設計の思想に触れたい | Verse | Lean 4 | 失敗コンテキストと効果システムは他にない |
| ブラウザ / エッジで動かしたい | MoonBit | Rust (wasm32) | wasm-gc 出力と JS 出力を切り替えられる |

## 各言語の「最初の 1 行」

インストールから Hello World までの最短コマンド。詳細は各 `docs/01-setup.md` (作成予定) と `docs/02-hello-world.md`。

| 言語 | インストール | Hello World の実行 |
|---|---|---|
| MoonBit | `curl -fsSL https://cli.moonbitlang.com/install/unix.sh \| bash` | `moon run cmd/main` |
| OxCaml | `opam switch create 5.2.0+ox --repos ox=git+https://github.com/oxcaml/opam-repository.git,default` | `dune exec ./bin/main.exe` |
| Lean 4 | `curl https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh -sSf \| sh` | `lake exe hello` |
| Quint | `npm i -g @informalsystems/quint` | `quint run hello.qnt` |
| Verse | UEFN を Epic Games Launcher から | UEFN で Launch Session |
| Dafny | GitHub Releases のバイナリ or `dotnet tool install -g dafny` | `dafny run hello.dfy` |
| Rust no_std | `rustup target add thumbv7em-none-eabihf` | `cargo run` |

## 動作確認の状況 (2026-09-02)

| 言語 | バージョン | 状態 |
|---|---|---|
| MoonBit | moon 0.1.20260827 | Hello World / 条件分岐 / モジュール すべて動作確認済み |
| OxCaml | OCaml 4.14.1 (ocamlopt) | 標準 OCaml 部分のみ確認。OxCaml 固有構文は未確認 |
| Lean 4 | v4.33.1 | すべて動作確認済み |
| Quint | 0.32.0 | すべて動作確認済み |
| Verse | — | 未確認 (UEFN が必要) |
| Dafny | 4.10.0 | すべて検証・実行済み (`--target:js`) |
| Rust | 1.94.1 | すべて動作確認済み。`thumbv7em-none-eabihf` ビルドも確認 |
