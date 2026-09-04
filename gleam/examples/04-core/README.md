# 04 OTP アクターと型安全な並行処理

## 学ぶこと

- メッセージをカスタム型で定義し、`Subject(Message)` で **型付きのメールボックス** を作る
- `actor.new(state) |> actor.on_message(handler) |> actor.start` で状態を持つプロセスを起動する
- ハンドラは `fn(state, msg) -> actor.Next(state, msg)`。状態は不変で、`actor.continue(new_state)` で次の状態を返す
- `process.send` (非同期) と `process.call` (返信用 Subject を乗せて同期) の使い分け
- `process.spawn` / `process.receive` で素のプロセスを扱う (並列合計)
- 100 個のメッセージを同時に送っても、アクターは順番に処理するので競合しない

## 依存

```sh
gleam add gleam_otp gleam_erlang
```

## 実行

```sh
gleam run      # Erlang ターゲットのみ (JavaScript では OTP は使えない)
gleam test
```

## 期待される出力

```
count = 15
after reset = 1
after 100 sends = 101
parallel sum = 45
```
