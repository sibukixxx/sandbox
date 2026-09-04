import core.{Increment, Reset}
import gleam/erlang/process
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn counter_test() {
  let assert Ok(counter) = core.start_counter()
  process.send(counter, Increment(3))
  process.send(counter, Increment(4))
  core.get(counter) |> should.equal(7)
  process.send(counter, Reset)
  core.get(counter) |> should.equal(0)
}
