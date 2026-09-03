# 02. Hello, World (`no_std` + `no_main`)

対応サンプル: [`examples/01-hello-world/`](../examples/01-hello-world/)

## 目的

`std` を外したときに「何が消えるか」を、最小の Hello World で体験する。

## 最小コード

```rust
#![no_std]
#![no_main]

use core::panic::PanicInfo;

#[link(name = "c")]
extern "C" {
    fn write(fd: i32, buf: *const u8, count: usize) -> isize;
}

#[no_mangle]
pub extern "C" fn main(_argc: i32, _argv: *const *const u8) -> i32 {
    const MSG: &[u8] = b"Hello, World!\n";
    unsafe { write(1, MSG.as_ptr(), MSG.len()); }
    0
}

#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}
```

`Cargo.toml` には `panic = "abort"` が必要。

## 実行

```sh
cargo run --quiet
```

期待される出力:

```
Hello, World!
```

## 解説

| 要素 | 意味 |
|---|---|
| `#![no_std]` | `std` をリンクしない。使えるのは `core` (と任意で `alloc`) だけ |
| `#![no_main]` | Rust の `fn main()` と起動ルーチン (`lang_start`) を使わない |
| `extern "C" fn main` | C ランタイム (`crt1.o`) が呼ぶシンボル `main` を自分で用意する |
| `#[link(name = "c")]` | `no_std` では libc が自動リンクされないので明示する |
| `#[panic_handler]` | パニック時の処理。`std` が提供していたので自分で書く |
| `panic = "abort"` | unwinding に必要な `eh_personality` がないため、abort にする |

`println!` が使えないのは、それが `std::io` の上に作られているから。
`core` には出力手段がなく、OS のシステムコールを直接呼ぶか、`core::fmt::Write` を自分で実装する必要がある。

## 他の言語ではこう書く

C の `write(1, "Hello\n", 6)` とほぼ同じ。Rust の `no_std` は「C と同じ土俵」で書くための仕組みと考えると分かりやすい。

## 落とし穴

- `#[link(name = "c")]` を忘れると `undefined symbol: __libc_start_main` でリンクに失敗する。
- `panic = "abort"` を忘れると `eh_personality` 言語アイテムがないというエラーになる。
- Edition 2024 では `#[unsafe(no_mangle)]` と `unsafe extern "C"` と書く必要がある。サンプルは 2021。
