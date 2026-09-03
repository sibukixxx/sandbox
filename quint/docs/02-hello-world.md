# 02. Hello, World

対応サンプル: [`examples/01-hello-world/`](../examples/01-hello-world/)

## 目的

Quint には print がない。「式を評価する」「状態機械を動かす」の 2 通りで Hello World を確認し、最小の状態機械の形を知る。

## 最小コード

```quint
module hello {
  pure def greeting: str = "Hello, World!"

  var message: str
  var count: int

  action init = all {
    message' = "",
    count' = 0,
  }

  action step = all {
    message' = greeting,
    count' = count + 1,
  }

  val countNonNegative = count >= 0
}
```

## 実行

```sh
quint typecheck hello.qnt
echo 'greeting' | quint -r hello.qnt::hello
quint run hello.qnt --max-steps=2 --invariant=countNonNegative
```

期待される出力:

```
>>> "Hello, World!"
```

```
[State 0] { count: 0, message: "" }
[State 1] { count: 1, message: "Hello, World!" }
[State 2] { count: 2, message: "Hello, World!" }
[ok] No violation found
```

## 解説

| 要素 | 意味 |
|---|---|
| `module` | 仕様の単位。1 ファイルに複数書ける |
| `pure def` | 状態に依存しない純粋な定義 |
| `var` | 状態変数。状態機械の「状態」を構成する |
| `action init` | 初期状態。`x' = v` (プライム) は「次の状態の x は v」 |
| `action step` | 1 ステップの遷移。`all { }` は列挙した全てが同時に成り立つ |
| `val` | 状態に依存する式。ここでは不変条件として使う |
| `quint run` | ランダムシミュレーション。`--invariant` で毎ステップ検査する |

## 他の言語ではこう書く

TLA+ の `Init == ... ; Next == ... ; Inv == ...` と同じ構造。Quint は型が付き、`x'` を代入のように書ける点が違う。

## 落とし穴

- `quint run` / `quint test` / REPL は初回に Rust 製評価器を GitHub から取得する。取得できない環境では `--backend=typescript` を付ける。
- `all { }` の中の要素はカンマ区切り。末尾カンマは許される。
- `var` を宣言したら、`init` と `step` の両方で全ての変数に `'` で値を与える必要がある。
