# 02 条件分岐を関数として書く

## 学ぶこと

- `if` / `switch` は **式**。`switch` は範囲 `1...9` と網羅性検査を持つ
- Optional `?T` と `orelse` / `if (opt) |v|`
- エラー共用体 `!T` と `try` / `catch`。「値なし」と「失敗理由」を区別する
- 定数引数の関数はコンパイル時に評価される (`const ABS_MIN = abs(-7)`)
- `test "..." { }` ブロックと `zig test`

## 実行

```sh
zig run basics.zig
zig test basics.zig
```

## 期待される出力

```
1: number / small
...
15: FizzBuzz / large
2 null 7
error: DivisionByZero
q = 0
All 3 tests passed.
```
