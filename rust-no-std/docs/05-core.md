# 05. `#![no_main]` / `panic_handler` とベアメタル実行

対応サンプル: [`examples/04-core/`](../examples/04-core/)

## 目的

OS も libc もない環境 (Cortex-M マイコン) で Rust を動かす。QEMU で実機なしに確認する。

## 最小コード

```rust
#![no_std]
#![no_main]

use core::fmt::Write;
use cortex_m_rt::entry;
use cortex_m_semihosting::{debug, hio};
use panic_halt as _;

#[entry]
fn main() -> ! {
    let mut stdout = hio::hstdout().unwrap();
    writeln!(stdout, "Hello from bare metal!").unwrap();
    debug::exit(debug::EXIT_SUCCESS);
    loop {}
}
```

```sh
cargo run   # .cargo/config.toml の runner が QEMU を起動する
```

## 解説

### 章 2 との違い

| | 章 2 (Linux, no_std) | 章 5 (ベアメタル) |
|---|---|---|
| OS | あり | なし |
| libc | あり (`write` を呼べる) | なし |
| エントリ | C ランタイムが `main` を呼ぶ | リセットベクタから直接 |
| 出力 | システムコール | セミホスティング (デバッガ経由) / UART |
| 終了 | `return 0` | 戻る先がない → `-> !` |

### 起動までに必要なもの

CPU がリセットされてから `main` が呼ばれるまでに、誰かがやらなければならないこと:

1. **ベクタテーブル**: 先頭にスタックポインタ初期値とリセットハンドラのアドレスを置く
2. **スタック**: RAM の末尾にスタックポインタを設定
3. **.data / .bss**: 初期値付き static を Flash から RAM にコピー、ゼロ初期化領域をクリア
4. `main` を呼ぶ

`cortex-m-rt` がこれを全部やる (C の `crt0` に相当)。`#[entry]` で「自分の main」を登録する。

### リンカスクリプト

```
MEMORY { FLASH : ORIGIN = 0x00000000, LENGTH = 256K
         RAM   : ORIGIN = 0x20000000, LENGTH = 64K }
```

`memory.x` にボードのメモリ配置を書き、`cortex-m-rt` の `link.x` がそれを読んでセクションを配置する。`build.rs` で `memory.x` をリンカの検索パスに置く。

### panic_handler

`panic-halt` (無限ループ)、`panic-semihosting` (メッセージを出して停止)、`panic-reset` (再起動) などから選ぶ。`use panic_halt as _;` は「リンクするだけ」の書き方。

### メモリの確保

ヒープがないので、バッファは `static mut` か `heapless` で確保する。`static mut` へのアクセスは `unsafe` で、`core::ptr::addr_of_mut!` で参照を作る。
割り込みと共有するなら `cortex_m::interrupt::Mutex` + `RefCell`。

### QEMU

`.cargo/config.toml` の `runner` に `qemu-system-arm -machine lm3s6965evb -semihosting-config enable=on` を書くと、`cargo run` で QEMU が起動し、セミホスティング出力がホストの端末に出る。実機がなくても開発を始められる。

## 他の言語ではこう書く

C では起動コードとリンカスクリプトを自分で書くか、ベンダの SDK を使う。Rust は `cortex-m-rt` が標準化しており、ボードが違っても `memory.x` を変えるだけで済む。
MoonBit の WASM や Verse の UEFN は「ランタイムがある環境」で、ベアメタルはその対極。

## 落とし穴

- `panic = "abort"` を `Cargo.toml` に書かないとリンクエラー (`eh_personality`)。
- `static mut` への `&mut` を直接作ると 2024 edition で警告 / エラー。`addr_of_mut!` を使う。
- ターゲット名を間違えると (M3 なら `thumbv7m`, M4F なら `thumbv7em-none-eabihf`) 命令セットが合わず動かない。
- セミホスティングはデバッガがないと停止する。実機では UART か RTT に切り替える。
