# 05. モード (local / unique / once) と unboxed 型

対応サンプル: [`examples/04-core/`](../examples/04-core/) (OxCaml switch が必要。**動作未確認**)

## 目的

OxCaml が OCaml に足した 2 つの柱、**モード** と **unboxed 型** を理解する。どちらも「GC 言語のまま、割り当てとメモリレイアウトを制御する」ための仕組み。

## モードとは

型が「値が何であるか」を表すのに対し、モードは「値をどう扱ってよいか」を表す。OxCaml では 3 つの軸がある。

| 軸 | モード | 意味 |
|---|---|---|
| 局所性 (locality) | `local` / `global` | `local` な値はその関数のリージョン (スタック) に置かれ、外に持ち出せない |
| 一意性 (uniqueness) | `unique` / `aliased` | `unique` な値への参照は 1 つだけ。安全に in-place 更新できる |
| 線形性 (linearity) | `once` / `many` | `once` な値 (主にクロージャ) は 1 回しか使えない |

既定は `global` / `aliased` / `many` で、これが標準 OCaml の振る舞い。モードを付けない限り何も変わらない。

### local_ と exclave_

```ocaml
let use_local () =
  let local_ p = (1, 2) in   (* スタックに置く *)
  sum_pair p                 (* エスケープしない使い方なら OK *)

let make_pair a b = exclave_ (a, b)   (* 呼び出し元のリージョンに置いて返す *)
```

`local_` な値を返そうとすると `local value escapes its region` エラー。
`exclave_` は「呼び出し元のリージョンで作る」という指定で、ローカルな値を返す関数を書ける。

### [@zero_alloc]

```ocaml
let[@zero_alloc] min_max a b = exclave_ if a < b then (a, b) else (b, a)
```

この関数がヒープ割り当てを行うとコンパイルエラー。レイテンシが重要なコードで「意図しない割り当て」を防ぐ。
`exclave_` と組み合わせると、タプルを返してもゼロアロケーションにできる。

### unique_

```ocaml
let overwrite (unique_ r : int ref) = r := 0; r
```

`unique_` な引数は、呼び出し側でそれ以降使えなくなる (Rust のムーブに近い)。
唯一の参照であることが分かるので、コピーせずに中身を書き換えて返す (in-place 更新) ができる。

## unboxed 型

標準 OCaml では `float` や複数フィールドのタプルはボックス化され、作るたびにヒープ割り当てが起きる。

| 型 | 意味 |
|---|---|
| `float#` | unboxed float。演算は `Float_u` モジュール |
| `int64#`, `int32#`, `nativeint#` | unboxed 整数 |
| `#(a * b)` | unboxed タプル。返り値に使っても割り当てなし |
| `{ x : float#; y : float# }` | フィールドが unboxed なレコード。1 レコード = 1 割り当て |

unboxed 値は **layout** (`float64`, `bits64`, `value` など) を持ち、`'a` (layout `value`) を期待するジェネリックな関数には渡せない。
これがボックス化の代わりに払うコストで、型注釈で layout を明示する必要がある場面がある。

## 他の言語ではこう書く

| 概念 | OxCaml | Rust |
|---|---|---|
| スタック割り当て | `local_` | 既定 (ヒープは `Box`) |
| 一意な所有 | `unique_` | 所有権 (既定) |
| 割り当てなしの検査 | `[@zero_alloc]` | `no_std` で構造的に不可能にする |
| unboxed 値 | `float#` | 既定 |

Rust は「全て明示」、OCaml は「全て GC」、OxCaml は「既定は GC、必要な所だけ明示」。

## 落とし穴

- モード付きの関数シグネチャは標準 OCaml のライブラリと互換性がない場合がある。`.mli` で公開 API のモードを決める。
- `local_` な値をクロージャに捕捉させると、クロージャも `local` になる。
- OxCaml は活発に変化中で、構文 (`local_` の位置、`@` 付き構文への移行など) が変わりうる。公式ドキュメントの日付を確認する。
- このリポジトリのサンプルは OxCaml でビルドできていない。動かない箇所があれば README の動作確認欄に記録する。
