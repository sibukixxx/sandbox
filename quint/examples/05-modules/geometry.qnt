// 別ファイルのモジュール。`import geometry.* from "./geometry"` で読み込まれる。

module geometry {
  // コンストラクタの引数は 1 つ。複数の値はレコードにまとめる
  type Shape = Circle(int) | Rect({ w: int, h: int })

  // 整数しかないので円周率は 3 で近似
  pure def area(s: Shape): int =
    match s {
      | Circle(r) => 3 * r * r
      | Rect(rec) => rec.w * rec.h
    }

  pure def totalArea(shapes: Set[Shape]): int =
    shapes.fold(0, (acc, s) => acc + area(s))
}
