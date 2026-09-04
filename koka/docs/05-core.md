# 05. 代数的効果とハンドラ

対応サンプル: [`examples/04-core/`](../examples/04-core/)

## 目的

Koka の中心である「効果の宣言」と「ハンドラ」を、例外 → 状態 → 非決定性の順に体験する。

## 最小コード

```koka
effect raise
  ctl raise(msg : string) : int

fun safe-div(a : int, b : int) : raise int
  if b == 0 then raise("division by zero") else a / b

// 例外として扱う (resume しない)
fun to-maybe(action : () -> <raise|e> a) : e maybe<a>
  with ctl raise(_msg) Nothing
  Just(action())

// 回復する (resume する)
fun with-default(default : int, action : () -> <raise|e> a) : e a
  with ctl raise(_msg) resume(default)
  action()
```

## 解説

### 効果 = 操作の宣言

`effect` は「こういう操作を呼べる」という宣言だけで、実装は持たない。`raise("...")` を呼ぶ関数の型には `raise` 効果が付く。

| 操作の種類 | 意味 |
|---|---|
| `fun op(...)` | 通常の関数のように値を返して再開する (最も軽い) |
| `ctl op(...)` | 継続 `resume` を受け取り、呼ばない / 1 回呼ぶ / 複数回呼ぶ、を選べる |

### ハンドラ = 操作の意味

`with ctl raise(msg) ...` で、それ以降のスコープの `raise` に意味を与える。ハンドラを通ると型から効果が消える (`<raise|e>` → `e`)。

同じ `safe-div` に対して:

- `Nothing` を返して resume しない → **例外**
- `resume(default)` → **既定値で回復**
- ログを集めるハンドラ → **ログ収集**

コードを変えずに振る舞いを変えられる。テストではモックのハンドラ、本番では実 I/O のハンドラ、という使い方が自然にできる。

### 状態

```koka
effect state<s>
  fun get() : s
  fun put(x : s) : ()

fun run-state(init : s, action : () -> <state<s>|e> a) : e a
  var st := init
  with handler
    fun get() st
    fun put(x) st := x
  action()
```

可変変数を効果として抽象化する。使う側 (`counter-demo`) は「状態がある」ことだけ知っていて、どこに保存されるかを知らない。

### 非決定性: resume を複数回呼ぶ

```koka
effect choose
  ctl choose(xs : list<a>) : a

fun all-choices(action : () -> <choose|e> a) : e list<a>
  with ctl choose(xs) xs.flatmap(fn(x) resume(x))
  [action()]
```

`resume` を選択肢の数だけ呼ぶと、全ての組み合わせが試される。バックトラック探索、パーサコンビネータ、確率的プログラミングがこの形で書ける。

### return 節

`with handler return(x) (x, [])` で、ハンドルされた計算の最終結果を変換できる。ログ収集 (`collect-logs`) はこれと `ctl` の組み合わせ。

## 他の言語ではこう書く

| 概念 | Koka | 他 |
|---|---|---|
| 例外 | `ctl raise` を resume しない | try / catch |
| 可変状態 | `state` 効果 | 変数、State monad |
| async | `ctl` + resume を後で呼ぶ | async / await |
| ジェネレータ | `ctl yield` | yield |
| 非決定性 | resume を複数回 | List monad、バックトラック |
| DI | 効果 + ハンドラ | インターフェース + 実装注入 |

Verse の `<decides>` / `<transacts>` は Koka の効果の固定された特殊例。OCaml 5 の `effect` / `perform` / `continue` は Koka の `ctl` / `resume` にほぼ対応する (ただし OCaml は複数回 resume 不可)。

## 落とし穴

- ハンドラの本体が効果を持つ (println など) と、`action` と結果の効果行に同じ効果が要る (`<log,console|e>` → `<console|e>`)。
- `fun` で宣言した操作は `ctl` でハンドルできない (警告)。両方使いたいなら `ctl` で宣言する。
- 多相な戻り値 (`: a`) の操作を `resume` で回復するには型が決まっている必要がある。サンプルでは `raise` を `int` にしている。
- `var` を使うハンドラは局所効果の扱いが難しい。`return` 節 + `ctl` の純粋な書き方の方が型が通りやすい。
