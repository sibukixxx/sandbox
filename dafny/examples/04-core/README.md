# 04 事前条件・事後条件・ループ不変条件で証明する

## 学ぶこと

- `ensures` (事後条件): 返り値について常に成り立つこと
- `requires` (事前条件): 呼び出し側の義務。破ると **実行前に** エラー
- `invariant` (ループ不変条件): while の毎周回で成り立つこと。これがないとループ後の性質が証明できない
- `decreases`: 停止性。自動で分からないときに書く
- `predicate` で「ソート済み」を定義し、仕様に使う
- `modifies` / `old(...)` / `multiset` で「配列を並べ替えただけ」を表す
- `lemma`: 実行されない証明

## 実行

```sh
dafny verify verify.dfy
dafny run verify.dfy          # または --target:js
```

## 期待される出力

```
Dafny program verifier finished with 13 verified, 0 errors
[1, 2, 5, 5, 6, 9]
index of 9: 5
index of 4: -1
abs(-7) = 7
```

## 試してみる

1. `BinarySearch` の `hi := mid;` を `hi := mid - 1;` にすると、不変条件が破れて検証エラーになる (正しく `hi := mid`)
2. `InsertionSort` の `invariant` を 1 行消すと、`ensures Sorted(a)` が証明できなくなる。どの不変条件が何のためにあるかが分かる
3. `Main` の `Div(1, 0)` のコメントを外すと `precondition could not be proved`
