# Verse の Hello, World。
# Verse のプログラムは UEFN の「デバイス」として動く。
# creative_device を継承したクラスを作り、OnBegin にコードを書く。

using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# `:=` は定義。`class(creative_device)` で creative_device を継承する。
hello_world_device := class(creative_device):

    # ゲーム開始時に呼ばれる。<override> で親のメソッドを上書き。
    # <suspends> はこの関数が非同期 (待機できる) であることを示す効果指定子。
    OnBegin<override>()<suspends>:void =
        Print("Hello, World!")
