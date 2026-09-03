# 04 失敗コンテキストと効果システム

## 学ぶこと

- `<decides>`: 失敗しうる関数。`F[Args]` (角括弧) で呼び、`if` / `for` などの失敗コンテキストに置く。bool と Option の両方の代わりになる
- `<transacts>`: 失敗コンテキスト内で `set` した変数は、失敗すると **ロールバック** される
- `<suspends>`: `Sleep` で待てる非同期関数。`race` (先着) / `sync` (全待ち) / `block` で並行実行を構造化する
- 効果は関数の型の一部。`<suspends>` でない関数から `Sleep` は呼べない

## 実行

1. `effects_device.verse` を UEFN プロジェクトに追加し、Build Verse Code
2. `effects_device` をレベルに配置して Launch Session

## 期待される出力

```
4 is even
5 is not even
10 / 3 = 3
1 / 0 fails
first even: 6
incremented to 1
incremented to 2
rolled back, count stays 2
rolled back, count stays 2
rolled back, count stays 2
countdown: 3
countdown: 2
countdown: 1
timeout!
task B done
task A done
all done
```

## 動作確認

- UEFN (バージョン): 未確認 — 構文は Verse 言語リファレンスに基づく。UEFN で確認したら日付とバージョンをここに記す。
