# 06. モジュール

対応サンプル: [`examples/05-modules/`](../examples/05-modules/)

## 目的

`include` / `module` / `import` / `export` と、`abstract module` + `refines` による「仕様と実装の分離」を理解する。

## 解説

### include と module

```dafny
include "Geometry.dfy"        // 別ファイルをそのまま取り込む (C の #include に近い)

module Units {
  export provides ToCm reveals Meters
  type Meters = int
  function ToCm(m: Meters): int { m * 100 }
  function ToMm(m: Meters): int { m * 1000 }   // export されないので外から見えない
}
```

| 書き方 | 意味 |
|---|---|
| `import Geometry` | `Geometry.Area` のように修飾して使う |
| `import opened Units` | 修飾なしで使う |
| `import C = Counter3` | 別名 |
| `export provides X` | X が存在することだけ公開 (定義は隠す) |
| `export reveals X` | X の定義まで公開 (検証器が中身を使える) |

`export` を書かなければ全てが `reveals` で公開される。

### abstract module と refines

```dafny
abstract module Counter {
  const MAX: int
  ghost predicate Valid(n: int) { 0 <= n <= MAX }
  method Next(n: int) returns (m: int)
    requires Valid(n)
    ensures Valid(m)
}

module Counter3 refines Counter {
  const MAX := 3
  method Next(n: int) returns (m: int) {
    if n < MAX { m := n + 1; } else { m := 0; }
  }
}
```

抽象モジュールは仕様 (requires / ensures) だけを書き、`refines` した実装が本体を埋める。
実装が仕様を満たさなければ検証エラーになる。「インターフェース + 契約」を言語レベルで検証できる。

## 他の言語ではこう書く

`export provides` は OCaml の `.mli` で型を抽象にするのと同じ。
`abstract module` + `refines` は Java の interface / 実装に「契約の検証」が付いたもの。

## 落とし穴

- `include` はテキスト取り込みなので、同じファイルを 2 回 include するとエラー。
- `provides` だけの関数は、外から呼べるが検証器はその中身を知らない。性質が必要なら `reveals` にするか、`ensures` を付ける。
- `Main` を module の中に置いても実行できる。トップレベルに `Main` があるときはそちらが優先。
