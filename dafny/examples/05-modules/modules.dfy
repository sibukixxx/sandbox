// モジュールの扱い。
//   - include で別ファイルを読み込む
//   - module で名前空間を作る (ネスト可)
//   - import M / import opened M / import X = M
//   - export で公開する名前を絞る
//   - abstract module + refines で「インターフェースと実装」を分ける

include "Geometry.dfy"

module Units {
  // export: 外部に見せるものを列挙する。provides は「存在だけ」、reveals は「定義まで」見せる
  export
    provides ToCm
    reveals Meters

  type Meters = int

  function ToCm(m: Meters): int { m * 100 }

  // export に含まれないので外からは見えない
  function ToMm(m: Meters): int { m * 1000 }
}

// 抽象モジュール: 仕様だけを書く
abstract module Counter {
  const MAX: int
  ghost predicate Valid(n: int) { 0 <= n <= MAX }

  method Next(n: int) returns (m: int)
    requires Valid(n)
    ensures Valid(m)
}

// 実装: 抽象モジュールを refines して本体を埋める。仕様を満たさなければ検証エラー
module Counter3 refines Counter {
  const MAX := 3

  method Next(n: int) returns (m: int)
  {
    if n < MAX { m := n + 1; } else { m := 0; }
  }
}

module Main {
  import Geometry                 // Geometry.Area のように参照
  import opened Units             // ToCm のように直接参照
  import C = Counter3             // 別名

  method Main() {
    var shapes := [Geometry.Circle(1), Geometry.Rect(1, 2)];
    print "total: ", Geometry.TotalArea(shapes), "\n";
    print "1.5m (as 150cm): ", ToCm(1) + 50, "\n";
    // print ToMm(1);  // export されていないのでエラー
    var n := 0;
    var i := 0;
    while i < 5
      invariant C.Valid(n)
    {
      n := C.Next(n);
      print n, " ";
      i := i + 1;
    }
    print "\n";
  }
}
