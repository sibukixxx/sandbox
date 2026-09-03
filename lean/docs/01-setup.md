# 01. セットアップ

## インストール

```sh
curl https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh -sSf | sh
```

`elan` (Rust の rustup に相当) が `~/.elan/bin` に入り、Lean 本体はプロジェクトの `lean-toolchain` に従って自動で取得される。

## バージョン確認

```sh
lean --version    # Lean (version 4.33.1, ...)
lake --version
```

## バージョン固定

プロジェクトごとに `lean-toolchain` ファイルを置く。

```
leanprover/lean4:v4.33.1
```

elan がこのファイルを読み、そのディレクトリでは指定した版の `lean` / `lake` が使われる。
Mathlib を使う場合は Mathlib が要求する版に合わせる。

## エディタ

VS Code 拡張「Lean 4」が事実上必須。証明の途中状態 (goal) が infoview にリアルタイムで表示される。
`lake build` より、エディタでファイルを開いて `#eval` / `#check` を見るのが日常の開発。

## 主なコマンド

| コマンド | 内容 |
|---|---|
| `lake new <name>` | プロジェクト生成 (`lakefile.toml` 形式) |
| `lake build` | ビルド |
| `lake exe <name>` | 実行ファイルを実行 |
| `lake test` | テスト (設定が必要) |
| `lean Main.lean` | 1 ファイルを検査し `#eval` の結果を表示 |
| `lake update` | 依存 (Mathlib など) を更新 |

## Mathlib

```toml
# lakefile.toml
[[require]]
name = "mathlib"
scope = "leanprover-community"
```

`lake exe cache get` でビルド済みキャッシュを取得する (自前ビルドは数時間かかる)。

## 落とし穴

- `.lake/` にビルド生成物が入る。`.gitignore` に追加する。
- 古い資料の `lakefile.lean` (Lean で書く設定) と、現在の既定 `lakefile.toml` が混在している。どちらも使える。
- Lean のバージョン間で tactic の挙動が変わることがある。`lean-toolchain` を必ずコミットする。
