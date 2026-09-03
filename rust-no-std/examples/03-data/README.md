# 03 データ構造とパターンマッチ

## 学ぶこと

- `struct` / `enum` / `derive`
- 再帰的な enum を **`Box` なし** (参照 + ライフタイム) で作る
- スライスと `iter().map().filter().sum()` はすべて `core`
- スライスパターン `[head, ..]`、`Option` を返す `find`
- Map がなくても enum をインデックスにした固定長配列で集計できる
- `alloc` を足すと `Vec` / `BTreeMap` が使える (`HashMap` は std 専用)

## 実行

```sh
cargo test --quiet
cargo test --quiet --features alloc
cargo build --quiet --target thumbv7em-none-eabihf
```

## 期待される出力

```
test result: ok. 2 passed; ...
test result: ok. 3 passed; ...
```
