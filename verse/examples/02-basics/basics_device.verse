# 条件分岐を「関数」として書く。
# Verse の if は式であり、さらに「条件」は「失敗しうる式」である。
# この 2 点が他言語との最大の違い。

using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# if-then-else 式 (1 行形式)。各分岐が同じ型 (string) を返す。
Sign(X:int):string =
    if (X > 0) then "positive"
    else if (X < 0) then "negative"
    else "zero"

# ブロック形式の if 式。最後の式が値になる。
Classify(X:int):string =
    if (X = 0):
        "zero"
    else if (X < 0):
        "negative"
    else if (X < 10):
        "small"
    else:
        "large"

# 複数条件は `and` / `or` で組み合わせる。
# `Mod` は整数の剰余。
FizzBuzz(N:int):string =
    if (Mod[N, 3] = 0 and Mod[N, 5] = 0) then "FizzBuzz"
    else if (Mod[N, 3] = 0) then "Fizz"
    else if (Mod[N, 5] = 0) then "Buzz"
    else "{N}"

# case 式: 整数リテラルで分岐する。
Describe(N:int):string =
    case (N):
        0 => "zero"
        1 => "one"
        _ => "many"

# --- Verse らしい部分: 失敗コンテキスト ---

# <decides> を付けた関数は「成功か失敗か」を返す。戻り値 void なら真偽値の代わりになる。
# 呼び出しは `IsPositive[X]` (角括弧) で、失敗しうる式として扱われる。
IsPositive(X:int)<decides><transacts>:void =
    X > 0

# <decides> 関数が値を返す場合、成功時だけ値が得られる。Option の代わりになる。
CheckedDiv(A:int, B:int)<decides><transacts>:int =
    B <> 0            # ここで失敗すると関数全体が失敗する
    Floor(A / B)      # 最後の式が戻り値。int / int は rational になるので Floor で int に戻す

# 失敗しうる式を if の条件に置くと「成功したら then」になる。
# 成功時の値は `if (Q := CheckedDiv[A, B])` のように束縛できる。
AverageOfTwo(A:int, B:int, Divisor:int):?int =
    if (X := CheckedDiv[A, Divisor], Y := CheckedDiv[B, Divisor]):
        option{Floor((X + Y) / 2)}    # 成功: option に値を包む
    else:
        false                  # 失敗: 空の option

basics_device := class(creative_device):

    OnBegin<override>()<suspends>:void =
        for (N := 1..15):
            Print("{N}: {FizzBuzz(N)} / {Classify(N)}")
        Print(Describe(1))

        # 失敗しうる式は if の条件に置く
        if (IsPositive[5]):
            Print("5 is positive")

        # option の中身も「失敗しうる式」で取り出す
        if (Avg := AverageOfTwo(6, 4, 2)?):
            Print("average = {Avg}")
        if (not AverageOfTwo(6, 4, 0)?):
            Print("division by zero -> no value")

        # for は「失敗した要素をスキップする」フィルタとしても働く
        Positives := for (X := array{-2, -1, 0, 1, 2}, IsPositive[X]) { X }
        Print("positives: {Positives.Length}")
