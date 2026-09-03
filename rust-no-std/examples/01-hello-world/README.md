# 01 Hello, World (`no_std` + `no_main`)

## 学ぶこと

- `#![no_std]` で std を外し、`core` だけで書く
- `#![no_main]` で Rust の起動ルーチンを外し、C の `main` を自分で用意する
- `#[panic_handler]` が必須になる理由と、`panic = "abort"` が必要な理由

## 実行

```sh
cargo run --quiet
```

## 期待される出力

```
Hello, World!
```

## 補足

`cargo build --release` してバイナリサイズを見ると、std 版 Hello World との差が分かる。

```sh
cargo build --release --quiet && ls -l target/release/hello
```
