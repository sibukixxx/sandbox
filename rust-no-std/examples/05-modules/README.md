# 05 モジュール構成

## 学ぶこと

- `mod` とファイル配置の対応 (`src/geometry/mod.rs`, `src/geometry/shapes.rs`)
- `pub` / `pub(crate)` / `pub use` (再エクスポート) / `super::` / `crate::`
- feature フラグで `no_std` → `alloc` → `std` を段階的に有効化する
- `no_std` クレートでも `core::f32::consts::PI` など core の資産はそのまま使える

## 実行

```sh
cargo test --quiet                    # no_std のまま (テストだけ std)
cargo test --quiet --features alloc   # alloc を有効にすると total_area のテストも走る
cargo build --quiet --target thumbv7em-none-eabihf   # 組込みターゲット向けにビルドできることを確認
```

最後のコマンドは `rustup target add thumbv7em-none-eabihf` が必要。

## 期待される出力

```
running 2 tests
..
test result: ok. 2 passed; ...

running 3 tests
...
test result: ok. 3 passed; ...
```
