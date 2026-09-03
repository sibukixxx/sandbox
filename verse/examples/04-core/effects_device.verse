# 失敗コンテキストと効果システム。
# Verse の関数には「効果指定子」が付き、何ができるかを型で表す:
#   <decides>   失敗しうる。呼び出しは失敗コンテキスト (if, for, ...) の中でのみ可
#   <transacts> 副作用を持つが、失敗したらロールバックされる
#   <suspends>  時間をかけてよい (Sleep, Await など非同期)
#   <computes>  純粋 (既定の一部)。<varies> なども

using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# ---- 1. <decides>: 失敗しうる関数 ----
# 戻り値が void でも「成功 / 失敗」という情報を持つ。bool の代わり。
IsEven(X:int)<decides><transacts>:void =
    Mod[X, 2] = 0

# 値を返す <decides>。成功時のみ値が得られる (Option の代わり)
SafeDiv(A:int, B:int)<decides><transacts>:int =
    B <> 0
    Floor(A / B)

# 配列から条件に合う最初の要素。見つからなければ失敗
FirstEven(Xs:[]int)<decides><transacts>:int =
    var Result:?int = false
    for (X : Xs, IsEven[X], not Result?):
        set Result = option{X}
    Result?    # option が空なら失敗

# ---- 2. <transacts>: 失敗時のロールバック ----
# 失敗コンテキストの中で set した変数は、失敗すると元に戻る。
counter := class:
    var Count<public>:int = 0

    # Count を増やしてから条件を検査する。条件が失敗すると Count の変更も巻き戻る
    TryIncrementIfBelow(Limit:int)<decides><transacts>:void =
        set Count += 1
        Count <= Limit      # ここで失敗すると set Count += 1 が無かったことになる

# ---- 3. <suspends>: 非同期 ----
# Sleep で待てる。並行実行の構文 (sync, race, branch, spawn) と組み合わせる
Countdown(From:int)<suspends>:void =
    var N:int = From
    loop:
        Print("countdown: {N}")
        if (N <= 0):
            break
        set N -= 1
        Sleep(0.5)

effects_device := class(creative_device):

    OnBegin<override>()<suspends>:void =
        # <decides> 関数は角括弧で呼び、失敗コンテキスト (if) に置く
        if (IsEven[4]):
            Print("4 is even")
        if (not IsEven[5]):
            Print("5 is not even")

        if (Q := SafeDiv[10, 3]):
            Print("10 / 3 = {Q}")
        if (not SafeDiv[1, 0]):
            Print("1 / 0 fails")

        if (E := FirstEven[array{1, 3, 6, 8}]):
            Print("first even: {E}")

        # ロールバック: 3 回目で Limit を超えて失敗し、Count は 2 のまま
        C := counter{}
        for (I := 1..5):
            if (C.TryIncrementIfBelow[2]):
                Print("incremented to {C.Count}")
            else:
                Print("rolled back, count stays {C.Count}")

        # 並行実行: race は先に終わった方を採用し、他をキャンセルする
        race:
            Countdown(3)
            block:
                Sleep(1.2)
                Print("timeout!")

        # sync は全て終わるまで待つ
        sync:
            block:
                Sleep(0.3)
                Print("task A done")
            block:
                Sleep(0.1)
                Print("task B done")
        Print("all done")
