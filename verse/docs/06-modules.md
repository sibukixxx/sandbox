# 06. モジュール

対応サンプル: [`examples/05-modules/`](../examples/05-modules/)

## 目的

Verse のモジュールがフォルダ構造と対応していること、`using` と `<public>` の使い方を知る。

## 解説

### フォルダ = モジュール

UEFN プロジェクトの Verse フォルダ以下では、サブフォルダがモジュールになる。
`Geometry/shapes.verse` にある定義は `using { Geometry }` で取り込める。
ファイル名はモジュール名に影響しない (1 フォルダに複数ファイルを置ける)。

### 標準モジュールのパス

`using { /Fortnite.com/Devices }` のように `/` で始まるパスは Epic が提供するモジュール。
自分のモジュールはプロジェクトからの相対名で参照する。

### ファイル内モジュール

```verse
Units := module:
    ToCm<public>(Meters:float):float = Meters * 100.0
```

参照は `Units.ToCm(1.5)` と修飾する。

### アクセス指定子

| 指定子 | 見える範囲 |
|---|---|
| `<public>` | どこからでも |
| `<internal>` (既定) | 同じモジュール内 |
| `<protected>` | クラスとそのサブクラス |
| `<private>` | そのクラス内 |

モジュールの外に出したいものには、型・関数・フィールドそれぞれに `<public>` が必要。

## 他の言語ではこう書く

Rust の `mod` はファイル内に `mod name { }` と書くか `mod name;` でファイルを指すが、
Verse はフォルダが自動的にモジュールになり、明示的な宣言は不要。Go のパッケージに近い。

## 落とし穴

- `<public>` を付け忘れると、`using` していても「見つからない」エラーになる。
- クラスのフィールドにも `<public>` が必要。`circle{Radius := 1.0}` で初期化するには `Radius<public>` にする。
