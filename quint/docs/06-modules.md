# 06. モジュール

対応サンプル: [`examples/05-modules/`](../examples/05-modules/)

## 目的

複数モジュールの読み込み方と、`const` を持つモジュールの **instance 化** を理解する。仕様を部品化して組み合わせる基本。

## 解説

### 3 種類の import

```quint
module main {
  import geometry.* from "./geometry"   // 別ファイル。* で全てを直接参照
  import units as u                     // 同ファイル内。u::toCm で参照
  import counter(MAX = 3) as c3         // const を与えて instance 化
}
```

| 書き方 | 意味 |
|---|---|
| `import M.*` | M の定義を修飾なしで使う |
| `import M as X` | `X::name` で使う |
| `import M from "./file"` | 別ファイル (`.qnt` 拡張子は省略) |
| `import M(C = v) as X` | `const C` を持つモジュールに値を与えて instance 化 |
| `export M.*` | 取り込んだものを、さらに外に公開する |

### パラメータ付きモジュール

```quint
module counter {
  const MAX: int
  var n: int
  action init = n' = 0
  action step = n' = if (n < MAX) n + 1 else 0
  val withinBounds = n >= 0 and n <= MAX
}
```

`const` は「まだ値が決まっていない定数」。このモジュール単体では実行できず、`import counter(MAX = 3) as c3` で instance 化して使う。
同じモジュールから `c3`、`c10` のように複数の instance を作れ、それぞれ独立した状態変数を持つ。

### instance の合成

```quint
action init = all { c3::init, c10::init }
action step = all { c3::step, c10::step }
val inv = c3::withinBounds and c10::withinBounds
```

複数の状態機械を `all { }` で束ねて 1 つの仕様にする。分散システムでは「ノード N 個」をこの方法で表す。
`quint run --main=main` のように、実行するモジュールを `--main` で指定する。

## 他の言語ではこう書く

TLA+ の `INSTANCE Counter WITH MAX <- 3` に相当。
OCaml のファンクタ (モジュールを受け取ってモジュールを返す) と同じ発想を、仕様記述向けに簡略化したもの。

## 落とし穴

- `const` を持つモジュールを `--main` に指定すると「const に値がない」エラーになる。instance 化した側を `--main` にする。
- `import M.*` で名前が衝突すると エラー。衝突するときは `as` で名前空間を分ける。
- 別ファイルの import パスはそのファイルからの相対パス。
