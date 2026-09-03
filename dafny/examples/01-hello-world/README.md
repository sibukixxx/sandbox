# 01 Hello, World

## 学ぶこと

- `method Main()` と `print`
- `dafny verify` (検証だけ) と `dafny run` (検証してから実行) の違い
- 検証済みコードを他言語にコンパイルする (`dafny build --target:py` など)

## 実行

```sh
dafny verify hello.dfy          # 検証だけ。"0 errors" なら OK
dafny run hello.dfy             # 検証 → コンパイル → 実行
dafny build --target:py hello.dfy && python3 hello-py/__main__.py   # Python に変換して実行
```

## 期待される出力

```
Dafny program verifier finished with 0 verified, 0 errors
Hello, World!
```
