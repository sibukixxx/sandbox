# 02 条件分岐を関数として書く

## 学ぶこと

- `if` / `match` は **式** なので、そのまま関数の戻り値になる
- `match` のガード (`n if n < 0`)、範囲パターン (`1..=9`)、タプルでの複数条件
- `const fn` によるコンパイル時評価、`Option` + `?` で「値なし」を分岐として扱う
- `#![cfg_attr(not(test), no_std)]` で「本体は no_std、テストは std」を両立する

## 実行

```sh
cargo test --quiet
```

## 期待される出力

```
running 4 tests
....
test result: ok. 4 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in 0.00s
```
