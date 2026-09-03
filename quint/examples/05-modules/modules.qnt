// モジュールの扱い。
//   - 1 ファイルに複数 module を書ける
//   - import M.* / import M as X / import M from "./file"
//   - const を持つモジュールは instance 化して使う (パラメータ付きモジュール)

// 同じファイル内の別モジュール
module units {
  pure def toCm(meters: int): int = meters * 100
  pure def toMm(meters: int): int = meters * 1000
}

// パラメータ (const) を持つモジュール。そのままでは実行できず、instance 化が必要
module counter {
  const MAX: int
  var n: int

  action init = n' = 0
  action step = n' = if (n < MAX) n + 1 else 0

  val withinBounds = n >= 0 and n <= MAX
}

module main {
  // 別ファイルから読み込む
  import geometry.* from "./geometry"

  // 名前空間付きで読み込む: units::toCm
  import units as u

  // const に値を与えて instance 化する。`import ... as` で名前を付ける
  import counter(MAX = 3) as c3
  import counter(MAX = 10) as c10

  // instance を組み合わせた状態機械
  action init = all { c3::init, c10::init }
  action step = all { c3::step, c10::step }

  // 両方の不変条件をまとめる
  val inv = c3::withinBounds and c10::withinBounds

  run geometryTest = all {
    assert(totalArea(Set(Circle(1), Rect({ w: 1, h: 2 }))) == 5),
    assert(u::toCm(2) == 200),
  }
}
