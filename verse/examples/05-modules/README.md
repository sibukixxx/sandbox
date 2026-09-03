# 05 モジュール

## 学ぶこと

- **フォルダ = モジュール**。`Geometry/shapes.verse` は `using { Geometry }` で取り込む
- `Name := module:` でファイル内にモジュールを定義し、`Name.Func()` で修飾参照する
- アクセス指定子: `<public>` (外部に公開) / 既定は `<internal>` (モジュール内)
- `interface` と `class(shape)` による実装、`<override>`
- 標準モジュールのパス (`/Fortnite.com/Devices`, `/Verse.org/Simulation`) も同じ `using` で取り込む

## 構成

```
05-modules/
├── Geometry/
│   └── shapes.verse       # モジュール Geometry: shape, circle, rect, TotalArea
└── modules_device.verse   # using { Geometry }, module Units, デバイス
```

## 実行

1. `Geometry/` フォルダごと UEFN プロジェクトの Verse フォルダにコピー
2. Build Verse Code → `modules_device` を配置 → Launch Session

## 期待される出力

```
circle: 3.141593
rect:   2.000000
total:  5.141593
1.5m = 150.000000cm
```

## 動作確認

- UEFN (バージョン): 未確認 — 構文は Verse 言語リファレンスに基づく。UEFN で確認したら日付とバージョンをここに記す。
