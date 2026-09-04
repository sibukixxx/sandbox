// OTP アクターと型安全な並行処理。Gleam を学ぶ最大の理由。
//
// BEAM (Erlang VM) では「プロセス」(軽量スレッド) がメッセージで通信する。
// Erlang ではメッセージは動的型だが、Gleam では Subject(msg) で型が付く。
// gleam_otp の actor は、状態を持つプロセスを「状態 + メッセージハンドラ」として書く。

import gleam/erlang/process.{type Subject}
import gleam/int
import gleam/io
import gleam/list
import gleam/otp/actor

// ---- 1. メッセージを型で定義する ----
// アクターが受け取れるのはこの型の値だけ。他の型を送るとコンパイルエラー
pub type Message {
  Increment(by: Int)
  Get(reply_to: Subject(Int))        // 返信先の Subject を持たせるのが「呼び出し」の定石
  Reset
  Shutdown
}

// ---- 2. ハンドラ: 状態とメッセージから次の状態を返す ----
// 状態は不変。「更新」は新しい状態を返すこと。副作用はここに閉じ込める
fn handle(state: Int, msg: Message) -> actor.Next(Int, Message) {
  case msg {
    Increment(by) -> actor.continue(state + by)
    Get(reply_to) -> {
      process.send(reply_to, state)
      actor.continue(state)
    }
    Reset -> actor.continue(0)
    Shutdown -> actor.stop()
  }
}

// ---- 3. アクターを起動する ----
pub fn start_counter() -> Result(Subject(Message), actor.StartError) {
  actor.new(0)
  |> actor.on_message(handle)
  |> actor.start
  |> result_map_data
}

fn result_map_data(
  r: Result(actor.Started(Subject(Message)), actor.StartError),
) -> Result(Subject(Message), actor.StartError) {
  case r {
    Ok(started) -> Ok(started.data)
    Error(e) -> Error(e)
  }
}

// ---- 4. 呼び出し側: send (非同期) と call (同期) ----
pub fn get(counter: Subject(Message)) -> Int {
  // call: 返信用の Subject を作り、メッセージに乗せて送り、返信を待つ (タイムアウト付き)
  process.call(counter, waiting: 100, sending: Get)
}

// ---- 5. 素のプロセス: spawn と receive ----
// アクターを使わず、プロセスと Subject だけで並行計算する
fn parallel_sum(chunks: List(List(Int))) -> Int {
  let reply = process.new_subject()
  // 各チャンクを別プロセスで合計し、結果を reply に送る
  list.each(chunks, fn(chunk) {
    process.spawn(fn() { process.send(reply, list.fold(chunk, 0, int.add)) })
  })
  // チャンク数だけ受信して合計する
  list.fold(chunks, 0, fn(acc, _) {
    let assert Ok(v) = process.receive(reply, within: 1000)
    acc + v
  })
}

pub fn main() -> Nil {
  let assert Ok(counter) = start_counter()

  process.send(counter, Increment(5))
  process.send(counter, Increment(10))
  io.println("count = " <> int.to_string(get(counter)))

  process.send(counter, Reset)
  process.send(counter, Increment(1))
  io.println("after reset = " <> int.to_string(get(counter)))

  // 100 個のメッセージを一斉に送っても、アクターは 1 つずつ順番に処理する (競合しない)
  list.each(list.repeat(1, 100), fn(_) { process.send(counter, Increment(1)) })
  io.println("after 100 sends = " <> int.to_string(get(counter)))

  process.send(counter, Shutdown)

  io.println("parallel sum = " <> int.to_string(parallel_sum([[1, 2, 3], [4, 5, 6], [7, 8, 9]])))
}
