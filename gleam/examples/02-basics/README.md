# 02 条件分岐を関数として書く

## 学ぶこと

- Gleam に `if` はない。すべて **`case` 式** で、ガード `_ if x > 0` を使う
- `case a, b { 0, 0 -> ... }` で複数の値を同時に照合する
- `Option` (値なし) と `Result` (失敗理由付き)。Gleam の標準は `Result`
- `use x <- result.try(...)` で Result を連鎖させる (他言語の `?` に相当)
- `gleeunit` によるテスト

## 実行

```sh
gleam run
gleam test
```

## 期待される出力

```
1: 1 / small
...
15: FizzBuzz / large
Ok(2)
Error(division by zero)
checked_div: none
```

```
3 passed, no failures
```
