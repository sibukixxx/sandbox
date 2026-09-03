# 05 モジュール

## 学ぶこと

- 1 ファイル複数 `module`、別ファイルからの `import geometry.* from "./geometry"`
- `import units as u` で名前空間付き参照 (`u::toCm`)
- `const` を持つモジュールを `import counter(MAX = 3) as c3` で **instance 化** する
- instance の `init` / `step` を `all { }` で合成して 1 つの状態機械にする

## 構成

```
05-modules/
├── geometry.qnt   # module geometry (別ファイル)
└── modules.qnt    # module units / counter / main
```

## 実行

```sh
quint typecheck modules.qnt
quint test modules.qnt --main=main
quint run modules.qnt --main=main --invariant=inv --max-steps=20
```

## 期待される出力

```
  main
    ok geometryTest passed 1 test(s)
```

```
[ok] No violation found (...ms).
```
