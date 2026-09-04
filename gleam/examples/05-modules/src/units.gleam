//// opaque type: 型は公開するが、コンストラクタは隠す。
//// 外部からは `meters(1.5)` でしか作れないので、不変条件 (負でない) を守れる。

pub opaque type Meters {
  Meters(Float)
}

pub fn meters(v: Float) -> Result(Meters, String) {
  case v <. 0.0 {
    True -> Error("negative length")
    False -> Ok(Meters(v))
  }
}

pub fn to_cm(m: Meters) -> Float {
  let Meters(v) = m
  v *. 100.0
}
