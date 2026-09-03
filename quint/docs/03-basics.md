# 03. 条件分岐を関数として書く

対応サンプル: [`examples/02-basics/`](../examples/02-basics/)

## 目的

Quint の全ての式が値を返すことを利用して、条件分岐を `pure def` として書き、`run` テストで検証する。

## 最小コード

```quint
pure def sign(x: int): str =
  if (x > 0) "positive"
  else if (x < 0) "negative"
  else "zero"

type Shape = Circle(int) | Square(int) | Point

pure def area(s: Shape): int =
  match s {
    | Circle(r) => 3 * r * r
    | Square(a) => a * a
    | Point => 0
  }

run signTest = all {
  assert(sign(3) == "positive"),
  assert(sign(0) == "zero"),
}
```

## 解説

- **`if (cond) a else b`** は式。条件は括弧必須、`then` は書かない。`else` は省略できない。
- **`and` / `or` / `not`** で複数条件を組み合わせる。タプルの match はないので、FizzBuzz は `n % 3 == 0 and n % 5 == 0` のように書く。
- **和型と `match`**: `type Shape = Circle(int) | Square(int) | Point`。コンストラクタの引数は 1 つだけ。複数の値はレコード `Rect({ w: int, h: int })` にまとめる。
- **Option 相当**: 標準にはないので `type Maybe = Some(int) | None` と自分で定義する。ネストした `match` で合成する。
- **集合に対する条件**: `xs.forall(x => x > 0)` / `xs.exists(x => x % 2 == 0)`。仕様記述では「全ての〜について」が頻出。
- **テスト**: `run name = all { assert(...), ... }` を書き、`quint test` で実行する。
- 途中の値に名前を付けるには `{ val isSmall = ...  if (...) ... }` とブロックにする。

## 他の言語ではこう書く

OCaml / Rust の `match` とほぼ同じだが、腕の先頭に `|` が必須、コンストラクタは 1 引数。
`int` から `str` への変換関数は標準にない (仕様記述では文字列を組み立てる必要がほぼないため)。

## 落とし穴

- `if` の条件に括弧を忘れると構文エラー。
- `str(n)` のような変換はない。分岐の結果はリテラル文字列か和型で返す。
- `pure def` の中では `var` を参照できない。状態を読むには `def` / `val` を使う。
