// 代数的効果とハンドラ。Koka を学ぶ最大の理由。
//
// 効果 (effect) = 「関数が行いうる操作」の宣言。ハンドラ = その操作の実装。
// 例外、状態、非決定性、ログ、依存性注入、ジェネレータ、async が
// すべて「効果 + ハンドラ」という 1 つの仕組みで書ける。

// ---- 1. 効果を宣言する ----
// `ctl` は制御を奪う操作 (継続 resume を持つ)。`fun` は通常の関数のように resume するだけの操作。
// ctl で宣言しておけば、ハンドラ側は fun でも ctl でも書ける
effect log
  ctl log(msg : string) : ()

effect raise
  ctl raise(msg : string) : int    // 「回復」して int を返すハンドラも書けるように int にしている

effect state<s>
  fun get() : s
  fun put(x : s) : ()

// ---- 2. 効果を使う関数 ----
// 型に `log`, `raise` などの効果が現れる。「この関数は log と raise をしうる」と読む
fun safe-div(a : int, b : int) : <log, raise> int
  log("div " ++ a.show ++ " / " ++ b.show)
  if b == 0 then raise("division by zero") else a / b

// state 効果で「可変変数」を表す。ループもすべて純粋な関数のまま
fun counter-demo() : <state<int>, log> int
  put(0)
  for(1, 5) fn(i)
    val cur : int = get()      // state<int> の s = int を確定させる注釈
    put(cur + i)
    log("count = " ++ (cur + i).show)
  get()

// ---- 3. ハンドラ: 効果の意味を与える ----
// 同じ safe-div に、違うハンドラを当てれば違う振る舞いになる

// log を標準出力に流す。ハンドラ自身が println するので、action と結果の両方の効果に console が要る
fun print-logs(action : () -> <log,console|e> a) : <console|e> a
  with fun log(msg) println("[log] " ++ msg)
  action()

// log を捨てる
fun ignore-logs(action : () -> <log|e> a) : e a
  with fun log(_msg) ()
  action()

// log を集めてリストで返す。`return` 節で最終結果を変換し、ctl で resume の結果にログを積む
fun collect-logs(action : () -> <log|e> a) : e (a, list<string>)
  with handler
    return(x) (x, [])
    ctl log(msg)
      val (x, logs) = resume(())
      (x, Cons(msg, logs))
  action()

// raise を maybe に変換する。ctl なので resume せずに抜ける (= 例外)
fun to-maybe(action : () -> <raise|e> a) : e maybe<a>
  with ctl raise(_msg) Nothing
  Just(action())

// raise を既定値で「再開」する。同じ効果でも、resume すれば例外ではなく「回復」になる
fun with-default(default : int, action : () -> <raise|e> a) : e a
  with ctl raise(_msg) resume(default)
  action()

// state を「現在の値」を引き回して実装する。resume に値を渡せる
fun run-state(init : s, action : () -> <state<s>|e> a) : e a
  var st := init
  with handler
    fun get() st
    fun put(x) st := x
  action()

// ---- 4. 非決定性: resume を複数回呼ぶ ----
effect choose
  ctl choose(xs : list<a>) : a

// 全ての選択肢を試して結果を集める。resume を何度も呼べるのが代数的効果の力
fun all-choices(action : () -> <choose|e> a) : e list<a>
  with ctl choose(xs) xs.flatmap(fn(x) resume(x))
  [action()]

fun pythagorean() : choose (int, int, int)
  val a = choose([1, 2, 3, 4, 5])
  val b = choose([1, 2, 3, 4, 5])
  val c = choose([1, 2, 3, 4, 5])
  if a * a + b * b == c * c && a < b then (a, b, c) else choose([])

fun main()
  // 同じ関数に違うハンドラ
  print-logs { println(with-default(-1) { safe-div(10, 2) }.show) }
  ignore-logs { println(with-default(-1) { safe-div(10, 0) }.show) }
  val (r, logs) = collect-logs { to-maybe { safe-div(7, 0) } }
  println(r.show ++ " logs=" ++ logs.show)

  // state
  val n = ignore-logs { run-state(0) { counter-demo() } }
  println("counter = " ++ n.show)

  // 非決定性
  println(all-choices { pythagorean() }.show)
