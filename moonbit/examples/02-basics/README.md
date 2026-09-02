# 02 条件分岐を関数として書く

## 学ぶこと

- `if` / `match` は **式** なので、そのまま関数の戻り値になる
- `match` のガード (`n if n < 0`)、範囲パターン (`1..=9`)、タプルでの複数条件
- `Int?` (Option) で「値なし」を分岐として扱い、タプルにして match で組み合わせる
- `test "name" { }` ブロックと `assert_eq`

## 実行

```sh
moon test            # test ブロックを実行
moon run cmd/main    # 1〜15 の FizzBuzz を表示
```

## 期待される出力

```
Total tests: 4, passed: 4, failed: 0.
```
