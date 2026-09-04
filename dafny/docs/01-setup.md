# 01. セットアップ

## インストール

方法 1: GitHub Releases のバイナリ (Z3 同梱、dotnet 不要で検証できる)

```sh
curl -fsSL -o dafny.zip https://github.com/dafny-lang/dafny/releases/download/v4.10.0/dafny-4.10.0-x64-ubuntu-20.04.zip
unzip dafny.zip && export PATH=$PWD/dafny:$PATH
```

方法 2: .NET tool

```sh
dotnet tool install -g dafny
```

## バージョン確認

```sh
dafny --version    # 4.10.0+...
```

## 実行に必要なもの

`dafny verify` は Z3 だけで動く。`dafny run` はコンパイル先のランタイムが必要。

| ターゲット | 必要なもの |
|---|---|
| C# (既定) | .NET SDK |
| `--target:js` | Node.js + `npm i -g bignumber.js` |
| `--target:py` | Python 3 |
| `--target:go` | Go |
| `--target:java` | JDK |

このリポジトリでは dotnet がない環境向けに `--target:js` を併記している。

## バージョン固定

`.tool-versions` にバージョン番号を書く。Dafny はメジャーバージョン間で構文が変わることがある (3 → 4 で `function method` が `function` になった等)。

## エディタ

VS Code 拡張「Dafny」。検証結果がエディタ上にリアルタイムで表示される (緑のチェック / 赤の波線)。

## 主なコマンド

| コマンド | 内容 |
|---|---|
| `dafny verify f.dfy` | 検証のみ |
| `dafny run f.dfy` | 検証 → コンパイル → 実行 |
| `dafny build --target:py f.dfy` | 他言語に変換 |
| `dafny test f.dfy` | `{:test}` 属性の method を実行 |
| `dafny format f.dfy` | 整形 |

## 落とし穴

- `dafny run` は `*.cs` / `*.csproj` などの生成物を作業ディレクトリに残す。`.gitignore` に入れる。
- 検証が遅いときは `--verification-time-limit` や `assert` の追加で Z3 を助ける。
