/-! # 命題と証明 (tactic 入門)
Lean の目玉: プログラムの性質を同じ言語で証明する。
`theorem 名前 (仮定) : 命題 := by tactic...` の形で書く。
エディタでカーソルを置くと、その時点の goal (証明すべきこと) が infoview に出る。 -/

/-! ## 1. 具体値の性質: decide / rfl -/

def double (n : Nat) : Nat := n + n

-- rfl: 定義を展開して両辺が同じ形になれば OK
example : double 3 = 6 := rfl

-- decide: 決定可能な命題を計算して確認
example : double 3 = 6 := by decide
example : 2 ^ 10 = 1024 := by decide

/-! ## 2. 全ての値について: intro / simp / omega -/

-- `∀ n, ...` は引数として受け取る。`intro` で仮定を導入する
theorem double_eq_two_mul : ∀ n : Nat, double n = 2 * n := by
  intro n          -- goal: double n = 2 * n
  unfold double    -- goal: n + n = 2 * n
  omega            -- 線形算術は omega が自動で解く

-- 引数に書けば intro は不要
theorem double_pos (n : Nat) (h : n > 0) : double n > 0 := by
  unfold double
  omega

/-! ## 3. 帰納法: induction -/

def sumTo : Nat → Nat
  | 0 => 0
  | n + 1 => (n + 1) + sumTo n

-- ガウスの公式。自然数についての性質は帰納法で証明する
theorem sumTo_formula (n : Nat) : 2 * sumTo n = n * (n + 1) := by
  induction n with
  | zero => rfl                       -- 基底: 2 * sumTo 0 = 0 * 1
  | succ k ih =>                      -- 帰納: ih は k についての仮定
    -- sumTo (k+1) を展開し、積を分配法則で展開して線形算術にする
    simp only [sumTo, Nat.mul_add, Nat.add_mul, Nat.mul_one, Nat.one_mul] at ih ⊢
    omega                             -- ih (文脈の仮定) を使って omega が閉じる

/-! ## 4. リストについての性質: induction + simp -/

def myReverse : List α → List α
  | [] => []
  | x :: xs => myReverse xs ++ [x]

theorem myReverse_length (xs : List α) : (myReverse xs).length = xs.length := by
  induction xs with
  | nil => rfl
  | cons x xs ih => simp [myReverse, ih]

/-! ## 5. 失敗する証明を読む -/

-- 間違った命題は証明できない。コメントを外すとエラーになる:
--   unsolved goals / omega could not prove the goal
-- example (n : Nat) : double n = n := by
--   unfold double
--   omega
--
-- エラーメッセージの読み方:
--   ⊢ n + n = n        ← 「⊢」の右が今証明すべき goal
--   h : ...            ← その上に並ぶのが使える仮定
-- goal が偽なら命題を直す。goal が真なのに閉じないなら tactic を変える。

/-! ## 6. 命題を型として扱う: 依存型の入口 -/

-- 「i < xs.length」という証明を引数に取る関数。境界チェックが型で保証される
def safeGet (xs : List Nat) (i : Nat) (h : i < xs.length) : Nat := xs[i]

example : safeGet [10, 20, 30] 1 (by decide) = 20 := rfl

-- 証明を持ち歩く構造体: 「正の数」
structure PosNat where
  val : Nat
  pos : val > 0

def PosNat.pred (p : PosNat) : Nat := p.val - 1

-- 構築時に証明が要るので、0 は作れない
def three : PosNat := ⟨3, by decide⟩

/-! ## 7. プログラムの仕様を証明する -/

def clamp (lo hi x : Nat) : Nat := max lo (min hi x)

theorem clamp_ge (lo hi x : Nat) : clamp lo hi x ≥ lo := by
  unfold clamp; omega

theorem clamp_le (lo hi x : Nat) (h : lo ≤ hi) : clamp lo hi x ≤ hi := by
  unfold clamp; omega

#eval clamp 0 10 42     -- 10
#eval three.pred        -- 2
