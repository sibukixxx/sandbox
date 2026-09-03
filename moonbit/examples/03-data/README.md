# 03 データ構造とパターンマッチ

## 学ぶこと

- `struct` / `enum` / `derive(Eq, Hash, Debug)` (Map のキーには `Hash`、`inspect` / `assert_eq` には `Debug`)
- 再帰的な `enum` (GC があるので `Box` 不要)
- `Array` の `map` / `filter` / `fold` / `search_by`
- 配列パターン `[head, ..]`、`Item?` (Option)
- `Map[K, V]` の生成・更新
- `inspect(x, content="...")` によるスナップショットテスト

## 実行

```sh
moon test
```

## 期待される出力

```
Total tests: 3, passed: 3, failed: 0.
```
