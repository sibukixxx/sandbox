# 02. Hello, World

対応サンプル: [`examples/01-hello-world/`](../examples/01-hello-world/)

## 目的

Lean を「証明器」ではなく「プログラミング言語」として動かし、`lake` と `#eval` の使い方を知る。

## 最小コード

```
01-hello-world/
├── lean-toolchain     # leanprover/lean4:v4.33.1
├── lakefile.toml
└── Main.lean
```

```toml
# lakefile.toml
name = "hello"
defaultTargets = ["hello"]

[[lean_exe]]
name = "hello"
root = "Main"
```

```lean
-- Main.lean
def main : IO Unit :=
  IO.println "Hello, World!"

#eval "Hello from #eval"
#eval 1 + 2
```

## 実行

```sh
lake build && lake exe hello     # ビルドして実行
lean Main.lean                   # #eval の結果だけ表示
```

期待される出力:

```
Hello, World!
```

## 解説

| 要素 | 意味 |
|---|---|
| `def main : IO Unit` | `IO Unit` は「副作用を伴い、意味のある値を返さない計算」の型 |
| `IO.println` | 文字列を出力する `IO` アクション |
| `#eval` | その場で式を評価してエディタ / 端末に表示する。ビルド不要 |
| `lean-toolchain` | elan が読むバージョン指定。プロジェクトごとに Lean のバージョンを固定する |
| `lakefile.toml` | Lake (ビルドツール) の設定。古い資料では `lakefile.lean` (Lean で書く形式) |

Lean での日常的な開発は `#eval` と VS Code の infoview が中心で、`lake build` は最後に行うことが多い。

## 他の言語ではこう書く

Haskell の `main :: IO ()` と同じ発想。`IO` はモナドで、`do` 記法で逐次処理を書く。

## 落とし穴

- `import` はファイルの先頭にしか書けない。コメントより前に置く。
- `lake build` の生成物は `.lake/` に入る。`.gitignore` に追加する。
- Mathlib を使うプロジェクトは初回ビルドに時間がかかる。Hello World では不要。
