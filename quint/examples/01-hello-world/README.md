# 01 Hello, World

## 学ぶこと

- `module` / `pure def` / `var` / `action init` / `action step` の最小構成
- `x' = ...` (プライム) で「次の状態」を書く
- `quint repl` で式を評価し、`quint run` で状態機械をシミュレーションする

## 実行

```sh
quint typecheck hello.qnt                      # 型検査
echo 'greeting' | quint -r hello.qnt::hello    # REPL で評価
quint run hello.qnt --max-steps=2 --invariant=countNonNegative   # シミュレーション
```

## 期待される出力

REPL:

```
>>> "Hello, World!"
```

`quint run`:

```
An example execution:

[State 0] { count: 0, message: "" }
[State 1] { count: 1, message: "Hello, World!" }
[State 2] { count: 2, message: "Hello, World!" }

[ok] No violation found (...ms).
```

## 補足

`quint run` / `quint test` / REPL は初回に Rust 製の評価器を GitHub Releases から取得する。
取得できない環境では `--backend=typescript` を付けると JS 実装で動く (遅いが結果は同じ)。
手動で入れる場合は `~/.quint/rust-evaluator-v<version>/quint_evaluator` に置く。
