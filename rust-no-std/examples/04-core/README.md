# 04 ベアメタル実行 (`#![no_main]` + Cortex-M + QEMU)

## 学ぶこと

- `#![no_main]` + `#[entry] fn main() -> !`: OS がないので main から戻る先がない
- `cortex-m-rt` が「リセットベクタ → スタック設定 → .data/.bss 初期化 → main」をやってくれる (C の crt0 に相当)
- `memory.x` (Flash / RAM の配置) と `-Tlink.x` (リンカスクリプト)
- `panic-halt` で `panic_handler` を用意する
- セミホスティング (`cortex-m-semihosting`) でデバッガ経由に出力する
- `.cargo/config.toml` の `runner` で `cargo run` が QEMU を起動する

## 実行

```sh
rustup target add thumbv7m-none-eabi
sudo apt install qemu-system-arm

cargo run            # ビルドして QEMU で実行
cargo size --release # cargo-binutils があればサイズ確認
```

## 期待される出力

```
Hello from bare metal!
fib = [0, 1, 1, 2, 3, 5, 8, 13, 21, 34]
buf[7] = 14
```

## 実機で動かすには

`memory.x` を実機の Flash / RAM に合わせ、セミホスティングの代わりに UART (`embedded-hal` の `serial::Write`) か RTT (`rtt-target`) を使う。書き込みは `probe-rs` / `cargo-embed`。
