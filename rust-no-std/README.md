# Rust (`no_std`)

> 標準ライブラリ (`std`) を使わず `core` (+ `alloc`) だけで書く Rust。OS のない環境 (ベアメタル、組込み、カーネル、WASM ランタイム) で動く。

## なぜ今学ぶのか

- Rust そのものは普及したが、**`no_std` を書ける人はまだ少ない**。組込み・カーネル (Linux, Windows) ・ブートローダ・スマートコントラクトなど需要は増える一方。
- `std` が隠している「OS が提供しているもの」(ヒープ、スレッド、I/O、パニック処理) が見えるようになり、通常の Rust の理解も深まる。
- `std` / `no_std` 両対応クレートの書き方はライブラリ作者に必須のスキル。

## 前提

通常の Rust (所有権、trait、`Result`) は既知とし、`std` との差分に集中する。

## セットアップ (最短)

```sh
rustup target add thumbv7em-none-eabihf x86_64-unknown-none wasm32-unknown-unknown
sudo apt install qemu-system-arm    # 章 5 で使用
cargo --version
```

## 章 5 (目玉概念) で扱うこと

- `#![no_std]` / `#![no_main]` / `#[panic_handler]`
- リンカスクリプトとエントリポイント
- QEMU (Cortex-M) または `x86_64-unknown-none` で `Hello` を出す

## 進め方の工夫

章 2 は **ホスト上で `cargo test` できる `no_std` ライブラリクレート** から始める。ベアメタル実行は章 5 まで持ち越し、最初の壁を低くする。

## 学習ロードマップ

| 章 | ドキュメント | サンプル | 学ぶこと |
|---|---|---|---|
| 0 | docs/00-why.md | — | 位置づけ、向く用途 |
| 1 | docs/01-setup.md | — | インストール、バージョン固定 |
| 2 | docs/02-hello-world.md | examples/01-hello-world | 最小プログラムとビルド |
| 3 | docs/03-basics.md | examples/02-basics | 変数・関数・制御構造 |
| 4 | docs/04-data.md | examples/03-data | データ構造・パターンマッチ |
| 5 | docs/05-core.md | examples/04-core | **#![no_std] / #![no_main] / panic_handler とベアメタル実行** |
| 6 | docs/06-project.md | examples/05-project | パッケージ管理・テスト |
| 99 | docs/99-resources.md | — | 公式資料・記事 |

(ドキュメントとサンプルは Phase 1 以降で順次追加。設計は [DESIGN.md](../DESIGN.md) 参照)

## 検証 (Phase 2)

```sh
../scripts/check-rust-no-std.sh   # cargo test (host) + cargo build --target ... + QEMU 実行
```

## バージョン固定

各 example の `rust-toolchain.toml`。
