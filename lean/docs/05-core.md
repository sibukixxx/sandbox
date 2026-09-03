# 05. 命題と証明 (tactic 入門)

対応サンプル: [`examples/04-core/`](../examples/04-core/)

## 目的

Lean の目玉である「プログラムの性質を同じ言語で証明する」を、tactic を使って体験する。

## 最小コード

```lean
def double (n : Nat) : Nat := n + n

example : double 3 = 6 := by decide

theorem double_eq_two_mul (n : Nat) : double n = 2 * n := by
  unfold double
  omega
```

## 解説

### 命題は型、証明は値

`theorem name (仮定) : 命題 := 証明` は、`def` と同じ形。命題 `double n = 2 * n` は型で、その証明が値。
`by` の後に **tactic** を並べて証明を組み立てる。エディタでは各行の時点の goal (`⊢` の右) と仮定が infoview に表示される。

### よく使う tactic

| tactic | 何をするか | 使う場面 |
|---|---|---|
| `rfl` | 両辺が定義的に等しい | 具体値、定義の展開だけで済むとき |
| `decide` | 決定可能な命題を計算 | 具体値のテスト |
| `intro h` | `∀ x` / `→` の左辺を仮定に入れる | 全称命題の冒頭 |
| `unfold f` | `f` の定義を展開 | 自分で定義した関数 |
| `simp [f, h]` | 単純化規則と与えた補題で書き換え | 多くの場面。最も頻用 |
| `omega` | 線形算術 (Nat / Int の `+`, `*定数`, `<`, `=`) を自動証明 | 数式の goal |
| `split` | `if` / `match` で場合分け | 条件分岐を含む関数 |
| `induction n with \| zero => .. \| succ k ih => ..` | 帰納法 | 再帰関数、リスト、自然数 |
| `exact h` | 仮定 `h` がそのまま goal | |
| `constructor` | `∧` や構造体を分解 | |

### 帰納法

```lean
theorem sumTo_formula (n : Nat) : 2 * sumTo n = n * (n + 1) := by
  induction n with
  | zero => rfl
  | succ k ih =>
    simp only [sumTo, Nat.mul_add, Nat.add_mul, Nat.mul_one, Nat.one_mul] at ih ⊢
    omega
```

`succ k ih` の `ih` が帰納法の仮定。`omega` は非線形な積 (`k * k`) を扱えないので、`simp only` で分配法則を展開してから渡す。

### 失敗する証明の読み方

```
error: omega could not prove the goal:
a possible counterexample may satisfy the constraints ...
```

- goal が偽 → 命題を直す
- goal が真だが閉じない → 別の tactic か補題が要る。`simp?` / `exact?` で候補を探せる
- `unsolved goals` → まだ goal が残っている。`·` で分岐ごとに処理する

### 命題を型として持ち歩く

```lean
def safeGet (xs : List Nat) (i : Nat) (h : i < xs.length) : Nat := xs[i]

structure PosNat where
  val : Nat
  pos : val > 0
```

添字の範囲や「正である」という不変条件を型の一部にすると、違反はコンパイルエラーになる。これが依存型の実用的な使い方。

## 他の言語ではこう書く

Dafny は `ensures` を書けば Z3 が自動証明する。Lean は自分で tactic を書く分、証明できる範囲が広く、証明そのものを読める。
Rust の型は「メモリ安全」までを保証するが、`clamp` の返り値が範囲内であることまでは保証しない。Lean はそこを `theorem` にできる。

## 落とし穴

- `omega` は `Nat` の引き算 (0 で止まる) も扱えるが、掛け算は定数倍のみ。
- `simp` が goal を変な形にしたら `simp only [...]` で規則を絞る。
- Mathlib を入れると `ring`, `linarith`, `nlinarith` など強力な tactic が使えるが、ビルドが重い。
