# 01 Hello, World

## 学ぶこと

- `fun main()` とインデントによるブロック (波括弧も使える)
- 関数の型に **効果** が付く (`console`)。推論されるので最初は意識しなくてよい
- `koka -e` (コンパイルして実行) と `koka` (対話環境)

## 実行

```sh
koka -e hello.kk           # ビルドして実行
koka -O2 -o hello hello.kk # 最適化して実行ファイルを作る
```

## 期待される出力

```
Hello, World!
```
