// Gleam の Hello, World。
// 型付きで BEAM (Erlang VM) 上で動く。同じコードが JavaScript にもコンパイルできる。
import gleam/io

pub fn main() -> Nil {
  io.println("Hello, World!")
}
