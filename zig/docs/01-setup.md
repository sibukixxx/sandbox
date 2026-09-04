# 01. セットアップ

## インストール

公式サイトのビルド済みバイナリを展開するだけ。インストーラもパッケージマネージャも不要。

```sh
curl -fsSL https://ziglang.org/download/0.16.0/zig-x86_64-linux-0.16.0.tar.xz | tar -xJ
export PATH=$PWD/zig-x86_64-linux-0.16.0:$PATH
```

macOS: `brew install zig`、Windows: `winget install zig.zig` / scoop。バージョン管理ツールは `zigup` や `zvm`。

## バージョン確認

```sh
zig version    # 0.16.0
```

## バージョン固定

`.tool-versions` (asdf / mise 形式) に `zig 0.16.0`。
Zig は 0.x で **リリースごとに破壊的変更** がある。特に 0.15 → 0.16 で標準ライブラリの I/O (`std.Io`) が変わり、Web 上の多くのサンプルはそのままでは動かない。
このリポジトリのサンプルは 0.16.0 で確認している。

## エディタ

VS Code 拡張「Zig Language」+ ZLS (言語サーバ)。`zig fmt` が整形。

## 主なコマンド

| コマンド | 内容 |
|---|---|
| `zig run file.zig` | ビルドして実行 |
| `zig test file.zig` | `test` ブロックを実行 |
| `zig build-exe file.zig` | 実行ファイルを作る (`-O ReleaseSmall` などで最適化) |
| `zig init` | `build.zig` 付きプロジェクトを生成 |
| `zig build` / `zig build run` / `zig build test` | build.zig のステップを実行 |
| `zig build -Dtarget=aarch64-linux-gnu` | クロスコンパイル |
| `zig fmt file.zig` | 整形 |
| `zig cc` | C コンパイラとして使う |

## 落とし穴

- `main` の型が 0.16 で `pub fn main(init: std.process.Init) !void` になった。古い `pub fn main() !void` も動くが、stdout の取得には `init.io` が要る。
- 標準出力の Writer は `flush` しないと何も出ない。
- 未使用の変数・引数はコンパイルエラー (`_ = x;` で明示的に捨てる)。
