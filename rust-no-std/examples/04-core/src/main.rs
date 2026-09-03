//! ベアメタル (OS なし) で動く Rust。QEMU の Cortex-M3 上で Hello を出す。
//!
//! 章 2 の Hello World は「libc はあるが std はない」状態だった。
//! ここでは libc も OS もない。あるのは CPU とメモリだけ。

#![no_std]
#![no_main]

use core::fmt::Write;
use cortex_m_rt::entry;
use cortex_m_semihosting::{debug, hio};
use panic_halt as _; // panic_handler を提供するクレート。使わなくてもリンクするために `as _`

/// リセット直後に呼ばれるエントリポイント。
/// `#[entry]` が cortex-m-rt のリセットハンドラから呼ばれる `main` を生成する。
/// 戻り値は `!` (発散): ベアメタルでは main から「戻る先」がない。
#[entry]
fn main() -> ! {
    // セミホスティング: デバッガ (ここでは QEMU) 経由でホストの stdout に書く
    let mut stdout = hio::hstdout().unwrap();
    writeln!(stdout, "Hello from bare metal!").unwrap();

    // core だけで計算する。ヒープなし、OS なし
    let fib: [u32; 10] = {
        let mut a = [0u32; 10];
        a[1] = 1;
        for i in 2..10 {
            a[i] = a[i - 1] + a[i - 2];
        }
        a
    };
    writeln!(stdout, "fib = {:?}", fib).unwrap();

    // 静的に確保したバッファ。ベアメタルでは「メモリは static で確保する」が基本
    static mut BUF: [u8; 16] = [0; 16];
    // SAFETY: シングルスレッドで、他に参照がない
    let buf = unsafe { &mut *core::ptr::addr_of_mut!(BUF) };
    for (i, b) in buf.iter_mut().enumerate() {
        *b = i as u8 * 2;
    }
    writeln!(stdout, "buf[7] = {}", buf[7]).unwrap();

    // QEMU を終了する (実機ではここで無限ループする)
    debug::exit(debug::EXIT_SUCCESS);
    loop {}
}
