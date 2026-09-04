import basics
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn sign_test() {
  basics.sign(3) |> should.equal("positive")
  basics.sign(-3) |> should.equal("negative")
  basics.sign(0) |> should.equal("zero")
}

pub fn fizzbuzz_test() {
  basics.fizzbuzz(15) |> should.equal("FizzBuzz")
  basics.fizzbuzz(9) |> should.equal("Fizz")
  basics.fizzbuzz(7) |> should.equal("7")
}

pub fn result_test() {
  basics.average_of_two(6, 4, 2) |> should.equal(Ok(2))
  basics.average_of_two(6, 4, 0) |> should.equal(Error("division by zero"))
  basics.safe_div(1, 0) |> should.be_error
}
