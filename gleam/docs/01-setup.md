# 01. セットアップ

## インストール

### Erlang/OTP

Gleam 1.18 が生成する Erlang コードは **OTP 27 以上** を要求する。apt の Erlang (25) では動かない。

```sh
# 方法 1: asdf / mise
mise use erlang@27

# 方法 2: ソースからビルド (このリポジトリの検証環境)
curl -fsSL -o otp.tgz https://github.com/erlang/otp/releases/download/OTP-27.3/otp_src_27.3.tar.gz
tar -xzf otp.tgz && cd otp_src_27.3
./configure --prefix=$HOME/otp27 --without-javac --without-wx && make -j$(nproc) && make install
export PATH=$HOME/otp27/bin:$PATH
```

### Gleam

```sh
curl -fsSL https://github.com/gleam-lang/gleam/releases/download/v1.18.0/gleam-v1.18.0-x86_64-unknown-linux-musl.tar.gz | tar -xz
export PATH=$PWD:$PATH
```

macOS: `brew install gleam`。JavaScript ターゲットだけなら Node.js があればよい。

## バージョン確認

```sh
gleam --version    # gleam 1.18.0
erl -noshell -eval 'io:format("~s~n",[erlang:system_info(otp_release)]), halt().'   # 27
```

## バージョン固定

- `.tool-versions` に `gleam 1.18.0` / `erlang 27.3`
- 各プロジェクトの `manifest.toml` が依存のロックファイル (コミットする)
- `gleam.toml` の `gleam = ">= 1.18.0"` で最低バージョンを宣言できる

## エディタ

VS Code 拡張「Gleam」。言語サーバは `gleam` に内蔵。`gleam format` で整形。

## 主なコマンド

| コマンド | 内容 |
|---|---|
| `gleam new <name>` | プロジェクト生成 |
| `gleam run` | ビルドして実行 (`--target javascript` で JS) |
| `gleam test` | `test/` の gleeunit テスト |
| `gleam add <pkg>` | Hex から依存を追加 |
| `gleam build` | ビルドのみ |
| `gleam format` | 整形 |
| `gleam docs build` | HTML ドキュメント生成 |

## 落とし穴

- OTP のバージョン。`syntax error before: '~'` が出たら OTP が古い。
- `escript` が PATH にないと `gleam run` が失敗する (`/usr/lib/erlang/bin` を PATH に足す)。
- `build/` にビルド生成物と依存パッケージが入る。`.gitignore` に追加する。
