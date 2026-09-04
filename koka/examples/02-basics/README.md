# 02 条件分岐を関数として書く

## 学ぶこと

- `if ... then ... elif ... else` / `match` は **式**
- `match` のガード (`n | n < 0`) とタプルの match
- `maybe<int>` (`Just` / `Nothing`) で「値なし」を表す
- **効果型**: `exn` (例外を投げうる)、`total` (純粋)。関数の型に書く
- `try(...) fn(err) ...` で exn 効果をハンドルする
- ドット記法: `n.show` は `show(n)`

## 実行

```sh
koka -e basics.kk
```

## 期待される出力

```
1: 1 / small
...
15: FizzBuzz / large
Just(2) Nothing
error: division by zero
q = 0
7
asserts ok
```
