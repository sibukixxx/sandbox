# 99. リソース

## 公式

- The Embedded Rust Book (組込み Rust の入門): https://docs.rust-embedded.org/book/
- The Embedonomicon (no_std バイナリを一から作る): https://docs.rust-embedded.org/embedonomicon/
- `core` ドキュメント: https://doc.rust-lang.org/core/
- `alloc` ドキュメント: https://doc.rust-lang.org/alloc/
- Rust リファレンス「no_std」: https://doc.rust-lang.org/reference/names/preludes.html#the-no_std-attribute
- プラットフォームサポート一覧: https://doc.rust-lang.org/rustc/platform-support.html

## クレート

- `cortex-m` / `cortex-m-rt`: https://github.com/rust-embedded/cortex-m
- `embedded-hal`: https://github.com/rust-embedded/embedded-hal
- `heapless` (固定容量のコレクション): https://github.com/rust-embedded/heapless
- `probe-rs` (書き込み・デバッグ): https://probe.rs/
- `defmt` / `rtt-target` (実機のログ): https://defmt.ferrous-systems.com/

## 読み物

- Writing an OS in Rust (x86_64 ベアメタル): https://os.phil-opp.com/
- Rust for Linux: https://rust-for-linux.com/
- Discovery Book (micro:bit で学ぶ): https://docs.rust-embedded.org/discovery/

## コミュニティ

- Rust Embedded Working Group: https://github.com/rust-embedded/wg
- Matrix: #rust-embedded:matrix.org

## このリポジトリで確認した版

Rust 1.94.1 stable。`thumbv7em-none-eabihf` ビルド、`thumbv7m-none-eabi` + QEMU (lm3s6965evb) 実行を確認。
