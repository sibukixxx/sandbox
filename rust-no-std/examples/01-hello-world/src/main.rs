//! no_std / no_main な Hello, World。
//! std を使わず、OS の write(2) システムコールを直接呼ぶ。

#![no_std]  // std を使わない。core だけが使える
#![no_main] // Rust 標準の main エントリを使わない (std の起動ルーチンが不要)

use core::panic::PanicInfo;

// libc の write(2)。no_std では libc が自動リンクされないので #[link] で明示する
#[link(name = "c")]
extern "C" {
    fn write(fd: i32, buf: *const u8, count: usize) -> isize;
}

// C ランタイム (crt1.o) が呼ぶ `main` を自分で用意する
#[no_mangle]
pub extern "C" fn main(_argc: i32, _argv: *const *const u8) -> i32 {
    const MSG: &[u8] = b"Hello, World!\n";
    // SAFETY: fd 1 (stdout) は有効で、MSG は有効な長さを持つ
    unsafe {
        write(1, MSG.as_ptr(), MSG.len());
    }
    0
}

// no_std ではパニック時の挙動を自分で決める必要がある
#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}
