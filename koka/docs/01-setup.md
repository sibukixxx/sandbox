# 01. セットアップ

## インストール

GitHub Releases のバイナリを展開する。C コンパイラ (gcc / clang) が実行時に必要 (Koka は C を生成する)。

```sh
curl -fsSL https://github.com/koka-lang/koka/releases/download/v3.2.2/koka-v3.2.2-linux-x64.tar.gz | tar -xz
export PATH=$PWD/bin:$PATH
```

公式のインストーラ: `curl -sSL https://github.com/koka-lang/koka/releases/latest/download/install.sh | sh`。
macOS: `brew install koka`。

## バージョン確認

```sh
koka --version    # Koka 3.2.2
```

## バージョン固定

`.tool-versions` に `koka 3.2.2`。

## エディタ

VS Code 拡張「Koka」(言語サーバ付き。`koka --language-server`)。

## 主なコマンド

| コマンド | 内容 |
|---|---|
| `koka -e file.kk` | コンパイルして実行 |
| `koka -i. -e main.kk` | `-i` で include パス (モジュールの探索場所) を指定 |
| `koka -O2 -o app file.kk` | 最適化して実行ファイルを作る |
| `koka` | 対話環境 (`:l file.kk` で読み込み) |
| `koka --target=js file.kk` | JavaScript を生成 (WASM も可) |

生成物は `.koka/` に入る。

## 落とし穴

- 標準ライブラリと同じ名前の関数 (`abs`, `sign`, `show` など) を定義すると曖昧エラーになる。別名にするかモジュール名で修飾する。
- `float64` の演算と表示には `import std/num/float64` が必要。
- `val` は予約語。フィールド名や変数名に使えない。
