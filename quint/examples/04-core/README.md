# 04 状態機械のシミュレーションと不変条件の検査

## 学ぶこと

- `var` / `init` / `step` / `action` で状態機械を書く
- `nondet x = oneOf(S)` で非決定的な選択、`any { }` で action の選択
- `all { 前提条件, x' = ... }` で「前提が偽なら選ばれない」action を書く
- `val inv = ...` を `--invariant` で検査し、**反例トレース** を読む
- `run xxxTest` で特定のシナリオ (`init.then(a).then(b)`) をテストする (名前が `Test` で終わるものが `quint test` の対象)
- バグを直した版を別 module にして、同じ不変条件で違反が消えることを確認する

## 実行

```sh
quint typecheck bank.qnt

# バグあり: withdraw で残高が負になる反例が出る
quint run bank.qnt --invariant=noNegative --max-steps=10

# 修正版: 違反なし
quint run bank.qnt --main=bankFixed --invariant=noNegative --max-steps=10

# シナリオテスト
quint test bank.qnt
```

## 期待される出力

バグあり:

```
An example execution:

[State 0] { balances: Map("alice" -> 0, "bob" -> 0) }
[State 1] { balances: Map("alice" -> -3, "bob" -> 0) }

[violation] Found an issue (...).
❌ Invariant violated
```

修正版:

```
[ok] No violation found (...).
```

## 反例トレースの読み方

- `[State N]` は各ステップ後の状態変数の値
- 最後の状態で不変条件が偽になっている。どの action で破れたかは、直前の状態との差分から読む
- `--seed=...` を付けると同じ反例を再現できる
- 反例が「本当のバグ」か「仕様の書き間違い」かを判断し、コード側 (action) か仕様側 (val) を直す
