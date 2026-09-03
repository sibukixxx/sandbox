# Lean 4

> 定理証明器であり、同時に実用的な関数型プログラミング言語。「プログラム」と「そのプログラムが正しい証明」を同じ言語で書ける。

## なぜ今学ぶのか

- 依存型を持つ言語の中で最も勢いがあり、Mathlib という巨大な数学ライブラリと、AI による自動証明研究の中心にいる。
- `#eval` で式をその場で評価でき、通常のプログラミング言語としても Haskell に近い書き心地。
- 「証明が通る = 仕様を満たす」を体験すると、他の言語での型設計やテストの考え方が変わる。

## セットアップ (最短)

```sh
curl https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh -sSf | sh
lean --version
lake --version
```

VS Code 拡張 `lean4` を入れると証明の状態 (goal) がリアルタイムに見える。

## 章 5 (目玉概念) で扱うこと

- `theorem` と tactic (`intro`, `simp`, `induction`, `rfl`, `decide`)
- 失敗する証明のエラーメッセージの読み方
- プログラムの性質 (例: リスト反転が対合) を証明する

## 学習ロードマップ

| 章 | ドキュメント | サンプル | 学ぶこと |
|---|---|---|---|
| 0 | [docs/00-why.md](./docs/00-why.md) | — | 位置づけ、向く用途 |
| 1 | [docs/01-setup.md](./docs/01-setup.md) | — | インストール、バージョン固定 |
| 2 | [docs/02-hello-world.md](./docs/02-hello-world.md) | [examples/01-hello-world](./examples/01-hello-world/) | 最小プログラムとビルド |
| 3 | [docs/03-basics.md](./docs/03-basics.md) | [examples/02-basics](./examples/02-basics/) | 条件分岐を関数として書く |
| 4 | [docs/04-data.md](./docs/04-data.md) | [examples/03-data](./examples/03-data/) | データ構造・パターンマッチ |
| 5 | [docs/05-core.md](./docs/05-core.md) | [examples/04-core](./examples/04-core/) | **命題と証明 (tactic 入門)** |
| 6 | [docs/06-modules.md](./docs/06-modules.md) | [examples/05-modules](./examples/05-modules/) | モジュールの扱い |
| 99 | docs/99-resources.md | — | 公式資料・記事 |

(リンクのある章は作成済み。残りは順次追加。設計は [DESIGN.md](../DESIGN.md) 参照)

## 検証 (Phase 2)

```sh
../scripts/check-lean.sh   # 各 example で lake build (+ lake test)
```

## バージョン固定

各 example の `lean-toolchain` ファイル (elan 標準)。Mathlib を使う example は CI の時間を考慮して分離する。
