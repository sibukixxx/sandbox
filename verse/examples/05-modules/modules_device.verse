# モジュールの扱い (2/2): using と、ファイル内でのモジュール定義。

using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# フォルダ Geometry (shapes.verse) をモジュールとして取り込む
using { Geometry }

# 1 つのファイルの中にモジュールを定義することもできる。
# 参照は `Units.ToCm(...)` のように修飾する。
Units := module:
    ToCm<public>(Meters:float):float = Meters * 100.0
    ToMm<public>(Meters:float):float = Meters * 1000.0

    # <public> がないのでモジュール外からは見えない
    Unused():void = {}

modules_device := class(creative_device):

    OnBegin<override>()<suspends>:void =
        C := circle{Radius := 1.0}
        R := rect{W := 1.0, H := 2.0}
        Print("circle: {C.Area()}")
        Print("rect:   {R.Area()}")
        Print("total:  {TotalArea(array{C, R})}")
        Print("1.5m = {Units.ToCm(1.5)}cm")
