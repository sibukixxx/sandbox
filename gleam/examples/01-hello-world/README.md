# 01 Hello, World

## 学ぶこと

- `gleam new` が生成する構成 (`gleam.toml`, `src/`, `test/`)
- `pub fn main() -> Nil` と `io.println`
- 同じコードを Erlang (BEAM) と JavaScript の両方で実行する

## 実行

```sh
gleam run                       # Erlang VM で実行
gleam run --target javascript   # Node で実行
gleam test                      # テスト (gleeunit)
```

## 期待される出力

```
Hello, World!
```
