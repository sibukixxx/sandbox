import data.{Add, Food, Mul, Num, Tool}
import gleam/dict
import gleam/option.{None, Some}
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn eval_test() {
  data.eval(Mul(Add(Num(1), Num(2)), Num(4))) |> should.equal(12)
}

pub fn list_test() {
  data.total_value(data.sample) |> should.equal(700)
  data.in_stock(data.sample) |> should.equal([data.Item("apple", 100, 3, Food), data.Item("bread", 200, 2, Food)])
  data.first_name(data.sample) |> should.equal(Some("apple"))
  data.first_name([]) |> should.equal(None)
}

pub fn dict_test() {
  let m = data.value_by_category(data.sample)
  dict.get(m, Food) |> should.equal(Ok(700))
  dict.get(m, Tool) |> should.equal(Ok(0))
}
