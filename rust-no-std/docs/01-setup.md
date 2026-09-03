# 01. セットアップ

## インストール

```sh
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup target add thumbv7em-none-eabihf x86_64-unknown-none wasm32-unknown-unknown
```

章 5 (ベアメタル実行) では QEMU も使う。

```sh
sudo apt install qemu-system-arm   # Cortex-M のエミュレーション
```

## バージョン確認

```sh
cargo --version    # cargo 1.94.1
rustup target list --installed
```

## バージョン固定

各 example に `rust-toolchain.toml` を置く。

```toml
[toolchain]
channel = "stable"
```

nightly 限定機能 (`build-std` など) を使う章では `channel = "nightly-2026-08-01"` のように日付で固定する。

## ターゲットの選び方

| ターゲット | 用途 |
|---|---|
| `x86_64-unknown-linux-gnu` (ホスト) | `no_std` ライブラリのテスト、libc 経由の Hello World |
| `thumbv7em-none-eabihf` | Cortex-M4/M7 (STM32, nRF52 など)。QEMU で実行可能 |
| `x86_64-unknown-none` | x86_64 ベアメタル (OS カーネル、ブートローダ) |
| `wasm32-unknown-unknown` | WASM。`no_std` + `alloc` で軽量モジュール |

`no_std` クレートのビルド確認は `cargo build --target thumbv7em-none-eabihf` が手軽。`std` に依存していればここで失敗する。

## エディタ

VS Code + rust-analyzer。ターゲットを切り替えるには `.vscode/settings.json` で `rust-analyzer.cargo.target` を設定する。

## 主なコマンド

| コマンド | 内容 |
|---|---|
| `cargo test` | ホストでテスト (`#![cfg_attr(not(test), no_std)]` が前提) |
| `cargo build --target <t>` | クロスビルド |
| `cargo build --release` | サイズ確認用 |
| `cargo objdump` / `cargo size` | `cargo-binutils` で生成物を調べる |

## 落とし穴

- `no_std` バイナリは `panic = "abort"` が必要 (`Cargo.toml` の `[profile.*]`)。
- 依存クレートが `std` を要求していると `no_std` ビルドが失敗する。`default-features = false` を確認する。
