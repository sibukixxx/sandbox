///|
/// newtype で単位を型にする。
pub(all) struct Meters(Double)

///|
pub fn Meters::to_cm(self : Meters) -> Double {
  self.0 * 100.0
}
