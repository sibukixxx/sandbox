# 02 条件分岐を関数として書く

## 学ぶこと

- `if (cond) then a else b` (1 行) とブロック形式の `if` は **式**
- `case` 式、`and` / `or`、文字列補間 `"{N}"`
- **失敗コンテキスト**: `<decides>` 関数は「成功 / 失敗」を返し、`Func[Args]` (角括弧) で呼ぶ
- `if (X := FailableExpr[...])` で成功時の値を束縛する
- `?int` (option) と `option{...}` / `false`、`Value?` で中身を取り出す
- `for (X := Xs, Cond[X])` の絞り込み (失敗した要素をスキップ)

## 実行

1. `basics_device.verse` を UEFN プロジェクトに追加し、Build Verse Code
2. `basics_device` をレベルに配置して Launch Session

## 期待される出力

```
1: 1 / small
2: 2 / small
3: Fizz / small
...
15: FizzBuzz / large
one
5 is positive
average = 5
division by zero -> no value
positives: 2
```

## 動作確認

- UEFN (バージョン): 未確認 — 構文は Verse 言語リファレンスに基づく。UEFN で確認したら日付とバージョンをここに記す。
