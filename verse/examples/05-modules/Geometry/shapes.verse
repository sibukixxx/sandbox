# モジュールの扱い (1/2): ファイル・フォルダとモジュールの対応。
#
# UEFN プロジェクトでは、Verse ファイルを置いたフォルダがそのままモジュールになる。
# このファイルはフォルダ Geometry にあるので、他のファイルからは
#     using { Geometry }
# で取り込める。ファイル名 (shapes.verse) はモジュール名には影響しない。

using { /Verse.org/Simulation }

# <public> を付けたものだけがモジュールの外から見える。
# 既定は <internal> (同じモジュール内のみ)。

# インターフェース
shape<public> := interface:
    Area<public>():float

circle<public> := class(shape):
    Radius<public>:float = 1.0
    Area<override>():float = 3.141592653589793 * Radius * Radius

rect<public> := class(shape):
    W<public>:float = 1.0
    H<public>:float = 1.0
    Area<override>():float = W * H

# モジュール外からは見えないヘルパー
Square(X:float):float = X * X

# 合計面積。配列の型は `[]shape`
TotalArea<public>(Shapes:[]shape):float =
    var Sum:float = 0.0
    for (S : Shapes):
        set Sum += S.Area()
    Sum
