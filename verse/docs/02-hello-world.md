# 02. Hello, World

対応サンプル: [`examples/01-hello-world/`](../examples/01-hello-world/)

## 目的

Verse プログラムが「UEFN のデバイス」として動くこと、関数定義の読み方を知る。

## 最小コード

```verse
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

hello_world_device := class(creative_device):
    OnBegin<override>()<suspends>:void =
        Print("Hello, World!")
```

## 実行

UEFN でファイルを追加 → Build Verse Code → デバイスをレベルに配置 → Launch Session。
Output Log に `Hello, World!` が出る。

## 解説

| 行 | 意味 |
|---|---|
| `using { /Fortnite.com/Devices }` | モジュールの取り込み。`creative_device` はここにある |
| `hello_world_device := class(creative_device):` | `:=` は定義。`class(親)` で継承。末尾 `:` のあとインデントで本体 |
| `OnBegin<override>()<suspends>:void =` | 関数名 `OnBegin`、指定子 `<override>`、引数なし、効果 `<suspends>`、戻り値 `void` |
| `Print(...)` | 標準出力ではなく UEFN の Output Log に出る |

Verse の関数シグネチャは `名前<指定子>(引数)<効果>:型` の順で読む。
`<suspends>` は「この関数は時間をかけてよい (Sleep などで待てる)」という効果で、`OnBegin` はこれを要求する。

## 他の言語ではこう書く

Rust や Go は `fn main()` がエントリポイントだが、Verse には `main` がない。
ゲームエンジン側がデバイスの `OnBegin` を呼ぶ「フレームワーク型」のエントリポイントである。

## 落とし穴

- スタンドアロンのコンパイラはなく、UEFN (Windows) が必須。このリポジトリの CI では実行できない。
- インデントが構文の一部。タブではなくスペース 4 つを使う。
