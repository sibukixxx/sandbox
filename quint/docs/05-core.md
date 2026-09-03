# 05. 状態機械のシミュレーションと不変条件の検査

対応サンプル: [`examples/04-core/`](../examples/04-core/)

## 目的

Quint の本領である「設計をモデルとして書き、性質が破れないかを機械に探させる」を、銀行口座の例で体験する。

## 最小コード

```quint
module bank {
  var balances: str -> int

  action init = balances' = ACCOUNTS.mapBy(_ => 0)

  action withdraw = {
    nondet who = oneOf(ACCOUNTS)
    nondet amount = oneOf(1.to(10))
    balances' = balances.setBy(who, b => b - amount)   // バグ: 残高チェックなし
  }

  action step = any { deposit, withdraw, transfer }

  val noNegative = ACCOUNTS.forall(a => balances.get(a) >= 0)
}
```

```sh
quint run bank.qnt --invariant=noNegative
```

## 解説

### 状態機械の 3 要素

| 要素 | Quint | 意味 |
|---|---|---|
| 状態 | `var` | 時間とともに変わる変数 |
| 初期状態 | `action init` | 全ての `var` に `'` で値を与える |
| 遷移 | `action step` | 1 ステップで状態がどう変わるか |

`x' = e` は「次の状態の x は e」。代入ではなく **制約** で、`all { }` の中では順序に意味がない。

### 非決定性

```quint
nondet who = oneOf(ACCOUNTS)
```

「誰でもよい」をシミュレータに選ばせる。`any { a, b, c }` は action の選択。
設計の検証では「起こりうる全ての順序」を考える必要があり、非決定性がそれを表す。

### 前提条件付き action

```quint
action transfer = all {
  balances.get(from) >= amount,   // false ならこの action は「有効でない」= 選ばれない
  balances' = ...,
}
```

`all` の中の bool 式は、偽ならその action 全体が起きなくなる。ガード条件の書き方。

### 不変条件と反例

`val noNegative = ...` を `--invariant` に渡すと、`quint run` は毎ステップ検査し、破れたらそこまでのトレースを出す。

```
[State 0] { balances: Map("alice" -> 0, "bob" -> 0) }
[State 1] { balances: Map("alice" -> 0, "bob" -> -3) }
[violation] Found an issue
```

反例から「withdraw に残高チェックがない」と分かる。修正版 (`bankFixed`) では違反が出ない。

### run によるシナリオテスト

```quint
run transferTest = init.then(...).then(transfer).then(all { assert(...), balances' = balances })
```

特定の操作列を書いて確認する。名前が `Test` で終わるものが `quint test` の対象。

### シミュレーションと検証の違い

| コマンド | 方法 | 保証 |
|---|---|---|
| `quint run` | ランダムに探索 | 見つかれば確実にバグ。見つからなくても安全とは限らない |
| `quint verify` | Apalache で有限ステップを網羅 (記号実行) | 指定ステップ数以内に違反がないことを保証 |

## 他の言語ではこう書く

TLA+ では `Init`, `Next`, `Inv` と `TLC` モデルチェッカ。Quint はそれを型付きの構文にしたもの。
Dafny は「実装が仕様を満たす」を証明するが、Quint は「仕様 (設計) が性質を満たす」を検査する。段階が違う。

## 落とし穴

- `to` は組込み (`1.to(10)`) なので変数名に使えない。
- `import bank.*` すると `init` / `step` が衝突する。派生モジュールは `import bank as b` で名前空間を分ける。
- 状態空間を有限にする (`ACCOUNTS` を 2 つ、金額を 1〜10 など)。無限だとモデル検査が終わらない。
