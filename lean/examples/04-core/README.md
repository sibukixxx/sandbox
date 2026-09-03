# 04 命題と証明 (tactic 入門)

## 学ぶこと

- `example` / `theorem` と `by` ブロック
- 具体値: `rfl` / `decide`。一般: `intro` / `unfold` / `simp` / `omega`
- 帰納法: `induction n with | zero => .. | succ k ih => ..`
- 失敗する証明のエラー (`unsolved goals`) の読み方
- 命題を型として持ち歩く: `safeGet` (添字の証明)、`PosNat` (不変条件付き構造体)
- プログラムの仕様 (`clamp` の範囲) を定理として証明する

## 実行

```sh
lake build          # すべての証明が検査される。エラーがなければ成功
lean Proofs.lean    # #eval の結果を表示
```

## 期待される出力

```
Build completed successfully
```

`lean Proofs.lean`:

```
10
2
```

## 試してみる

セクション 5 のコメントを外して `lake build` すると、`omega could not prove the goal` と goal `n + n = n` が表示される。
