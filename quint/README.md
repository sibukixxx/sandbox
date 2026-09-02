# Quint

> Informal Systems が開発する、TLA+ の考え方をモダンな構文で書ける仕様記述言語。分散システムやプロトコルの設計を **実行・シミュレーション・モデル検査** できる。

## なぜ今学ぶのか

- 「コードを書く前に設計を検証する」技術は差がつくが、TLA+ は構文の壁が高い。Quint は型付き・プログラマ向け構文でその壁を下げる。
- `quint run` でランダムシミュレーション、`quint verify` (Apalache) で網羅的モデル検査。反例がトレースとして出る。
- 合意アルゴリズム、決済、ステートマシンなど「バグると高くつく」領域で使われている。

## セットアップ (最短)

```sh
npm i -g @informalsystems/quint
quint --version
```

モデル検査 (`quint verify`) には Java 17+ が必要 (Apalache を自動取得)。

## 章 5 (目玉概念) で扱うこと

- `var` / `action` / `init` / `step` による状態機械
- `quint run --invariant` で不変条件を検査し、反例トレースを読む
- 題材: 銀行口座 → 二相コミット → 簡易リーダー選出

## 学習ロードマップ

| 章 | ドキュメント | サンプル | 学ぶこと |
|---|---|---|---|
| 0 | docs/00-why.md | — | 位置づけ、向く用途 |
| 1 | docs/01-setup.md | — | インストール、バージョン固定 |
| 2 | [docs/02-hello-world.md](./docs/02-hello-world.md) | [examples/01-hello-world](./examples/01-hello-world/) | 最小プログラムとビルド |
| 3 | [docs/03-basics.md](./docs/03-basics.md) | [examples/02-basics](./examples/02-basics/) | 条件分岐を関数として書く |
| 4 | docs/04-data.md | examples/03-data | データ構造・パターンマッチ |
| 5 | docs/05-core.md | examples/04-core | **状態機械のシミュレーションと不変条件の検査** |
| 6 | [docs/06-modules.md](./docs/06-modules.md) | [examples/05-modules](./examples/05-modules/) | モジュールの扱い |
| 99 | docs/99-resources.md | — | 公式資料・記事 |

(リンクのある章は作成済み。残りは順次追加。設計は [DESIGN.md](../DESIGN.md) 参照)

## 検証 (Phase 2)

```sh
../scripts/check-quint.sh   # quint typecheck + quint run --invariant (verify は任意ジョブ)
```

## バージョン固定

`package.json` の `devDependencies`。
