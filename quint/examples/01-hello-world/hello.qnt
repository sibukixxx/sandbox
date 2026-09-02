// Quint の「Hello, World」。
// Quint は仕様記述言語なので print 文はない。代わりに
//   1. 純粋な定義を REPL で評価する
//   2. 状態機械を定義してシミュレータで動かす
// の 2 通りで「動いている」ことを確認する。

module hello {
  // 純粋な定義。状態を持たない
  pure def greeting: str = "Hello, World!"

  // --- ここから状態機械 ---
  // 状態変数
  var message: str
  var count: int

  // 初期状態
  action init = all {
    message' = "",
    count' = 0,
  }

  // 1 ステップ。all { } の中は同時に成り立つ必要がある
  action step = all {
    message' = greeting,
    count' = count + 1,
  }

  // 不変条件: 常に成り立ってほしい性質。`quint run --invariant` で検査する
  val countNonNegative = count >= 0
}
