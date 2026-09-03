# 01 Hello, World

## 学ぶこと

- `moon.mod` (モジュール) と `moon.pkg` (パッケージ) の 2 層構造
- `fn main` と `println`
- 同じコードを WASM と JS の両方で実行する

## 実行

```sh
moon run cmd/main                       # 既定ターゲット (wasm-gc) で実行
moon run cmd/main --target js           # JS バックエンドで実行
moon run cmd/main --target native       # ネイティブバックエンドで実行
```

## 期待される出力

```
Hello, World!
```
