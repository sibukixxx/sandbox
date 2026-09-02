# OxCaml

> Jane Street が公開した OCaml の拡張。標準 OCaml と互換性を保ちつつ、**モード** (`local` / `unique` / `once`) と **unboxed 型** で GC に頼らない高性能コードを書ける。

## なぜ今学ぶのか

- Rust の所有権に近い安全性を、**GC 言語の書き心地のまま**手に入れる設計。「GC あり言語の次」の方向性を最前線で学べる。
- `local_` によるスタック割り当て、`unique_` による in-place 更新、`float#` / `int64#` などの unboxed 型で **ゼロアロケーション** を型で保証できる (`[@zero_alloc]`)。
- 標準 OCaml のコードはそのまま動くので、OCaml 学習と同時に進められる。

## セットアップ (最短)

```sh
# opam が必要
opam switch create 5.2.0+ox --repos ox=git+https://github.com/oxcaml/opam-repository.git,default
eval $(opam env --switch 5.2.0+ox)
ocaml -version
```

## 章 5 (目玉概念) で扱うこと

- `local_` と stack allocation、`exclave_`
- `unique_` / `once_` と所有権
- unboxed 型 (`float#`, `#(int * int)`) と layout
- `[@zero_alloc]` でアロケーションなしをコンパイラに検査させる

## 注意

OxCaml は活発に変化中。バージョンは switch 名 + opam-repository のコミットハッシュで固定する。

## 学習ロードマップ

| 章 | ドキュメント | サンプル | 学ぶこと |
|---|---|---|---|
| 0 | docs/00-why.md | — | 位置づけ、向く用途 |
| 1 | docs/01-setup.md | — | インストール、バージョン固定 |
| 2 | [docs/02-hello-world.md](./docs/02-hello-world.md) | [examples/01-hello-world](./examples/01-hello-world/) | 最小プログラムとビルド |
| 3 | [docs/03-basics.md](./docs/03-basics.md) | [examples/02-basics](./examples/02-basics/) | 条件分岐を関数として書く |
| 4 | docs/04-data.md | examples/03-data | データ構造・パターンマッチ |
| 5 | docs/05-core.md | examples/04-core | **モード (local / unique / once) と unboxed 型** |
| 6 | [docs/06-modules.md](./docs/06-modules.md) | [examples/05-modules](./examples/05-modules/) | モジュールの扱い |
| 99 | docs/99-resources.md | — | 公式資料・記事 |

(リンクのある章は作成済み。残りは順次追加。設計は [DESIGN.md](../DESIGN.md) 参照)

## 検証 (Phase 2)

```sh
../scripts/check-oxcaml.sh   # 各 example で dune build && dune test (Docker イメージをキャッシュ)
```
