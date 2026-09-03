# 06. モジュールの扱い

対応サンプル: [`examples/05-modules/`](../examples/05-modules/)

## 目的

`no_std` クレートでのモジュール分割、可視性、feature フラグによる `alloc` / `std` の段階的有効化を理解する。

## 解説

### mod とファイルの対応

```
src/
├── lib.rs               # pub mod geometry;  pub mod units { ... }
└── geometry/
    ├── mod.rs           # pub mod shapes;  trait Shape;  pub(crate) fn square
    └── shapes.rs        # use super::{square, Shape};
```

| 書き方 | 意味 |
|---|---|
| `pub mod geometry;` | `src/geometry/mod.rs` または `src/geometry.rs` を読み込む |
| `pub mod units { ... }` | 同じファイル内にインラインで定義する |
| `use super::square` | 親モジュールの項目 |
| `use crate::geometry::Shape` | クレートルートからの絶対パス |

### 可視性

| 指定子 | 見える範囲 |
|---|---|
| なし | 同じモジュールと子モジュール |
| `pub(crate)` | 同じクレート内 |
| `pub` | 外部クレートからも (ただし親モジュールも `pub` である必要がある) |
| `pub use` | 再エクスポート。深い階層の項目をトップレベルから使えるようにする |

### feature フラグで `no_std` → `alloc` → `std`

```toml
[features]
default = []
alloc = []
std = ["alloc"]
```

```rust
#![cfg_attr(not(any(test, feature = "std")), no_std)]

#[cfg(feature = "alloc")]
extern crate alloc;

#[cfg(feature = "alloc")]
pub fn total_area(shapes: &alloc::vec::Vec<&dyn Shape>) -> f32 { ... }
```

ライブラリを `no_std` 対応にする定石。既定は `no_std`、`alloc` で `Vec` / `String` などが使えるようになり、`std` で通常の Rust として振る舞う。
組込みターゲットでビルドできることは `cargo build --target thumbv7em-none-eabihf` で確認する。

## 他の言語ではこう書く

MoonBit や Go はディレクトリ = パッケージで、明示的な `mod` 宣言がない。
Rust は `mod` を書いた場所がモジュールツリーを決めるので、ファイルを置いただけでは認識されない。

## 落とし穴

- `pub` を付けた項目でも、親モジュールが非公開なら外から見えない。
- `extern crate alloc;` は `#![no_std]` のクレートで `alloc` を使うために必要 (2018 edition 以降でも)。
- feature は加算的であるべき。`std` を有効にしたときに `no_std` 向け API が消えるような設計は避ける。
