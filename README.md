# Programming Languages Sandbox

実験的なプログラミング言語の学習・比較リポジトリ。各言語をドキュメント + 実行可能なサンプルコードで扱っています。

## 言語

- MoonBit (WASM-first 関数型言語)
- OxCaml (Jane Street 製 OCaml 拡張)
- Lean 4 (定理証明器兼関数型言語)
- Quint (分散システム仕様記述言語)
- Verse (Epic/UEFN 関数論理型言語)
- Dafny (検証指向言語)
- Rust no_std (標準ライブラリなし Rust)

## 構成

各言語ディレクトリ (`<lang>/`) は：
- `docs/` - ドキュメント (なぜ学ぶか、セットアップ、基本機能)
- `examples/` - 実行可能なサンプルコード

`comparison/` ディレクトリでは同じテーマを複数言語で横断比較しています。

## 検証

```sh
./scripts/check-all.sh            # 全言語 (Verse を除く)
./scripts/check-lean.sh           # 特定言語のみ
```

詳細は [DESIGN.md](./DESIGN.md) を参照してください。
