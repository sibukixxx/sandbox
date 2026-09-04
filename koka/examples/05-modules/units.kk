module units

import std/num/float64

// struct を newtype として使う。pub にすると外からコンストラクタもアクセサも見える
pub struct meters
  value : float64     // `val` は予約語なので使えない

pub fun to-cm(m : meters) : float64
  m.value * 100.0

// 同じ名前の関数が他モジュールにあっても、モジュール名で修飾すれば区別できる: units/show
pub fun show(m : meters) : string
  m.value.show ++ "m"
