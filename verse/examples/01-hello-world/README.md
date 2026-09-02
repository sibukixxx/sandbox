# 01 Hello, World

## 学ぶこと

- `using { ... }` によるモジュールの取り込み
- `名前 := class(creative_device):` でデバイスを定義する
- `OnBegin<override>()<suspends>:void` の読み方 (名前、指定子、引数、効果、戻り値型)
- `Print` の出力は UEFN の Output Log に出る

## 実行

1. UEFN でプロジェクトを開き、Verse Explorer で `hello_world_device.verse` を追加 (またはこのファイルの内容を貼り付け)
2. **Build Verse Code** (Ctrl+Shift+B)
3. Content Browser に現れた `hello_world_device` をレベルにドラッグして配置
4. **Launch Session** でセッションを起動し、Output Log を見る

## 期待される出力

Output Log:

```
LogVerse: : Hello, World!
```

## 動作確認

- UEFN (バージョン): 未確認 — このリポジトリの CI では検証できない。UEFN で確認したら日付とバージョンをここに記す。
