# 02 条件分岐を関数として書く

## 学ぶこと

- `if ... then ... else` / `match` は **式** なので、そのまま関数の戻り値になる
- 引数を直接パターンマッチする `def f : Nat → String | 0 => ... | n + 1 => ...`
- `Option` と `do` 記法での早期 return
- 依存 if (`if h : i < xs.size then xs[i]`) で「条件の証明」を分岐内で使う
- `example ... := by decide` で具体値の性質を、`theorem` で一般の性質を証明する

## 実行

```sh
lake build && lake exe basics
```

## 期待される出力

```
1: 1 / small
2: 2 / small
3: Fizz / small
...
15: FizzBuzz / large
successor of 4
(some 2)
none
20
0
```
