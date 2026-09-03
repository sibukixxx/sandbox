// モジュール = 配布単位。モジュール名 "learn/modules" が全パッケージのパス接頭辞になる。
//
// 外部モジュールに依存するときはここに書く (`moon add moonbitlang/x` で追加できる):
// import {
//   "moonbitlang/x@0.4.6",
// }
name = "learn/modules"
version = "0.1.0"
preferred_target = "wasm-gc"
