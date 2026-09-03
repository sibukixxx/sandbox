# 05. 各言語の「目玉概念」を 7 言語で

各言語を学ぶ最大の理由になる機能を、同じ構成 (何を保証するか、どう書くか、何が起きるか) で並べる。

## 結論 (一覧表)

| 言語 | 目玉概念 | 保証・効果 | いつ分かるか | 誰が確認するか | 動作確認 |
|---|---|---|---|---|---|
| MoonBit | WASM / JS 両バックエンド + インラインテスト | 同じソースが数百バイトの WASM と ESM になる | ビルド時 | `moon test --target` で全ターゲット | ✅ |
| OxCaml | モード (`local` / `unique`) + unboxed 型 | ヒープ割り当てとエスケープを型で制御 | コンパイル時 | 型検査 (`[@zero_alloc]`) | ❌ 未確認 |
| Lean 4 | 命題と証明 (tactic) | 関数の性質が全入力で成り立つ | コンパイル時 | 自分で証明を書き、カーネルが検査 | ✅ |
| Quint | 状態機械 + 不変条件の検査 | 設計が性質を破る操作列がないか | シミュレーション / モデル検査時 | シミュレータが反例を探す | ✅ |
| Verse | 失敗コンテキスト + 効果システム | 失敗時の自動ロールバック、効果の型追跡 | コンパイル時 (効果) / 実行時 (失敗) | 型検査 + ランタイム | 📝 未確認 |
| Dafny | `requires` / `ensures` / `invariant` | 仕様が全入力で成り立つ | コンパイル時 | Z3 が自動証明 | ✅ |
| Rust no_std | `#![no_main]` + ベアメタル実行 | OS も libc もない環境で動く | リンク時 / 実行時 | QEMU で実行 | ✅ |

## 言語ごとのコード

### MoonBit: WASM / JS バックエンド → [examples](../moonbit/examples/04-core/)

```moonbit
#export_name("fib")
pub fn fib(n : Int) -> Int {
  if n < 2 { n } else { fib(n - 1) + fib(n - 2) }
}

test "fib" { assert_eq(fib(10), 55) }
```

```sh
moon build --target wasm-gc --release   # core.wasm (233 バイト)
moon build --target js --release        # core.js (ESM)
moon test --target js                   # 同じテストを JS で
```

`pkgtype(kind: "foreign_library")` と `#export_name` だけでホストから呼べる。Rust の `wasm-bindgen` に相当する層がない。

### OxCaml: モードと unboxed 型 → [examples](../oxcaml/examples/04-core/) (未確認)

```ocaml
let[@zero_alloc] min_max a b = exclave_ if a < b then (a, b) else (b, a)

let overwrite (unique_ r : int ref) = r := 0; r

type vec2 = { x : float#; y : float# }
let dot (a : vec2) (b : vec2) : float# = Float_u.(a.x * b.x + a.y * b.y)
```

`local_` で値をスタックに置き、`[@zero_alloc]` で割り当てなしを検査、`unique_` で一意な所有。GC 言語のまま Rust 的な制御を「必要な所だけ」足す。

### Lean 4: 命題と証明 → [examples](../lean/examples/04-core/)

```lean
theorem sumTo_formula (n : Nat) : 2 * sumTo n = n * (n + 1) := by
  induction n with
  | zero => rfl
  | succ k ih =>
    simp only [sumTo, Nat.mul_add, Nat.add_mul, Nat.mul_one, Nat.one_mul] at ih ⊢
    omega

structure PosNat where
  val : Nat
  pos : val > 0
```

帰納法を tactic で書く。証明が通れば全ての `n` について成り立つ。`PosNat` のように証明を型に埋め込むと、不正な値は構築できない。

### Quint: 状態機械と不変条件 → [examples](../quint/examples/04-core/)

```quint
action withdraw = {
  nondet who = oneOf(ACCOUNTS)
  nondet amount = oneOf(1.to(10))
  balances' = balances.setBy(who, b => b - amount)   // バグ: 残高チェックなし
}
val noNegative = ACCOUNTS.forall(a => balances.get(a) >= 0)
```

```
[State 1] { balances: Map("alice" -> 0, "bob" -> -3) }
[violation] Found an issue
```

「誰が」「いくら」を非決定的に選ばせ、不変条件が破れる操作列をシミュレータに探させる。反例が具体的なトレースで出る。

### Verse: 失敗コンテキストと効果 → [examples](../verse/examples/04-core/) (未確認)

```verse
TryIncrementIfBelow(Limit:int)<decides><transacts>:void =
    set Count += 1
    Count <= Limit      # 失敗すると set Count += 1 が巻き戻る

race:
    Countdown(3)
    block:
        Sleep(1.2)
        Print("timeout!")
```

`<decides>` 関数は成功 / 失敗を返し、`<transacts>` 内の副作用は失敗時に自動でロールバックされる。`<suspends>` と `race` / `sync` で並行処理を構造化する。

### Dafny: 契約による自動証明 → [examples](../dafny/examples/04-core/)

```dafny
method BinarySearch(a: array<int>, key: int) returns (idx: int)
  requires Sorted(a)
  ensures idx >= 0 ==> idx < a.Length && a[idx] == key
  ensures idx < 0 ==> forall k :: 0 <= k < a.Length ==> a[k] != key
{
  var lo, hi := 0, a.Length;
  while lo < hi
    invariant 0 <= lo <= hi <= a.Length
    invariant forall k :: 0 <= k < lo ==> a[k] < key
    invariant forall k :: hi <= k < a.Length ==> a[k] > key
    decreases hi - lo
  { ... }
}
```

仕様と不変条件を書けば Z3 が証明する。挿入ソートの「並べ替えただけ」(`multiset` の保存) まで自動で通る。

### Rust no_std: ベアメタル実行 → [examples](../rust-no-std/examples/04-core/)

```rust
#![no_std]
#![no_main]

#[entry]
fn main() -> ! {
    let mut stdout = hio::hstdout().unwrap();
    writeln!(stdout, "Hello from bare metal!").unwrap();
    debug::exit(debug::EXIT_SUCCESS);
    loop {}
}
```

`cortex-m-rt` が起動コードを、`memory.x` がメモリ配置を提供し、`cargo run` で QEMU の Cortex-M3 上で動く。OS も libc もない。

## 違いはどこから来るか

1. **「何を保証したいか」が言語の設計を決めている**。正しさ (Lean, Dafny, Quint)、性能 (OxCaml, Rust no_std)、実行環境 (MoonBit, Verse) の 3 方向に分かれる。
2. **正しさ系の 3 言語は「誰が証明するか」が違う**。Lean は人が書く (最も強い)、Dafny は Z3 が自動 (最も楽)、Quint は探索で反例を探す (実装ではなく設計を対象)。
3. **性能系の 2 言語は「既定」が逆**。Rust は全て明示で `no_std` はさらに削る方向、OxCaml は GC が既定で必要な所だけモードを足す方向。
4. **実行環境系の 2 言語は「ランタイムを持っている」**。MoonBit は WASM ランタイム、Verse は UEFN。ベアメタルの Rust とは対極。
5. **失敗の扱い**。Verse の失敗コンテキスト + ロールバック、Quint の非決定性、Lean / Dafny の「証明できない = コンパイルエラー」は、いずれも「間違いを早く見つける」ための仕組み。

## どれを選ぶか

| こういう人 | この言語 | 最初にやること |
|---|---|---|
| 「正しさを証明する」を最短で体験したい | Dafny | `examples/04-core` の不変条件を 1 行消して壊す |
| 証明そのものを書けるようになりたい | Lean 4 | `sumTo_formula` の帰納法を写経する |
| 分散システムの設計を検証したい | Quint | 銀行口座に「送金の上限」を足して反例を探す |
| GC 言語で割り当てを制御したい | OxCaml | OxCaml switch を作り `[@zero_alloc]` を試す |
| マイコン・OS を書きたい | Rust no_std | QEMU で動かしてから `memory.x` を実機に合わせる |
| ブラウザで速いコードを動かしたい | MoonBit | `core.wasm` のサイズを見てから `web/index.html` を開く |
| 新しい言語設計の思想に触れたい | Verse | `<transacts>` のロールバックを UEFN で確認する |
