# 05. OTP アクターと型安全な並行処理

対応サンプル: [`examples/04-core/`](../examples/04-core/)

## 目的

BEAM のプロセスとメッセージを、Gleam の型で安全に扱う。`gleam_otp` の actor がその中心。

## 最小コード

```gleam
pub type Message {
  Increment(by: Int)
  Get(reply_to: Subject(Int))
  Shutdown
}

fn handle(state: Int, msg: Message) -> actor.Next(Int, Message) {
  case msg {
    Increment(by) -> actor.continue(state + by)
    Get(reply_to) -> {
      process.send(reply_to, state)
      actor.continue(state)
    }
    Shutdown -> actor.stop()
  }
}

let assert Ok(started) = actor.new(0) |> actor.on_message(handle) |> actor.start
let counter = started.data
process.send(counter, Increment(5))
let n = process.call(counter, waiting: 100, sending: Get)
```

## 解説

### プロセスとメッセージ

BEAM のプロセスは軽量 (数百万個作れる)、メモリを共有せず、メッセージで通信する。1 プロセスは 1 度に 1 メッセージを処理するので、状態の競合が起きない。
Erlang ではメッセージは何でも送れるが、Gleam では **`Subject(msg)`** (型付きのメールボックス) を通して送るため、`Subject(Message)` に `String` は送れない。

### アクター

`gleam_otp` の actor は「状態 + メッセージハンドラ」でプロセスを書く枠組み。

| 要素 | 役割 |
|---|---|
| `actor.new(初期状態)` | ビルダー |
| `actor.on_message(handle)` | `fn(state, msg) -> Next(state, msg)` |
| `actor.continue(new_state)` | 次の状態で継続 |
| `actor.stop()` | 停止 |
| `actor.start` | プロセスを起動し、`Started(pid:, data: Subject)` を返す |

### send と call

- `process.send(subject, msg)`: 非同期。送りっぱなし
- `process.call(subject, waiting: ms, sending: Get)`: 返信用の `Subject` を作ってメッセージに乗せ、返信を待つ。`Get(reply_to: Subject(Int))` のようにメッセージ型に返信先を含めるのが定石

### 素のプロセス

`process.spawn(fn() { ... })` で関数を別プロセスで実行し、`process.new_subject()` + `process.receive(subject, within: ms)` で結果を受け取る。アクターは不要で並列計算だけしたいときに使う。

### 監視ツリー (このサンプルの先)

`gleam_otp` には `supervision` があり、アクターが落ちたら再起動する「let it crash」を型付きで構成できる。

## 他の言語ではこう書く

| | Gleam | Elixir | Go |
|---|---|---|---|
| 並行単位 | プロセス | プロセス | goroutine |
| 通信 | `Subject(msg)` (型付き) | メッセージ (動的型) | channel (型付き) |
| 状態を持つプロセス | actor | GenServer | struct + mutex / channel |
| 障害時 | supervisor が再起動 | supervisor | 自分で書く |

Rust の `std::sync::mpsc` や Verse の `spawn` と比べると、BEAM は「落ちたら再起動」までが標準装備である点が違う。

## 落とし穴

- OTP は Erlang ターゲット専用。`--target javascript` では `gleam_otp` を使えない。
- `process.call` はタイムアウトすると **クラッシュ** する。返信を必ず送るハンドラにする。
- `gleam_otp` 1.x で API が変わった (`actor.start(state, handler)` → ビルダー方式)。古い記事に注意。
