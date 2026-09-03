# 03 データ構造

## 学ぶこと

- `enum` / `struct` (値型) / `class` (参照型)
- 代数的データ型はないので、再帰的なデータはクラスの継承 + `<override>` で表す
- `for (I : Items, Cond) { I }` は map + filter を兼ねる式
- `?item` (option)、`Items[0]` (添字アクセスは失敗しうる式)
- `[category]int` (map) と `set M[K] = V`

## 実行

1. `data_device.verse` を UEFN プロジェクトに追加し、Build Verse Code
2. `data_device` をレベルに配置して Launch Session

## 期待される出力

```
(1 + 2) * 4 = 12
total: 700
in stock: 2
find bread: qty=2
find milk: none
first: apple
Food: 700, Tool: 0
```

## 動作確認

- UEFN (バージョン): 未確認 — 構文は Verse 言語リファレンスに基づく。UEFN で確認したら日付とバージョンをここに記す。
