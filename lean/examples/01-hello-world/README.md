# 01 Hello, World

## 学ぶこと

- `def main : IO Unit` と `IO.println`
- `lakefile.toml` / `lean-toolchain` の役割
- `#eval` でビルドせずに式を評価する (Lean は REPL より `#eval` を多用する)

## 実行

```sh
lake build && ./.lake/build/bin/hello    # ビルドして実行
lake exe hello                           # 上と同じ
lean Main.lean                           # #eval の結果だけ表示 (ビルドしない)
```

## 期待される出力

```
Hello, World!
```

`lean Main.lean` の出力:

```
"Hello from #eval"
3
```
