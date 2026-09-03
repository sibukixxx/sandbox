# 03 データ構造とパターンマッチ

## 学ぶこと

- `datatype` (列挙、レコード、再帰型) と `match`
- `seq` の `|s|` / `s[0]` / `s[1..]` と再帰による map / filter / fold
- `Option<T>` を datatype で定義する
- `map<K, V>` の `m[k := v]` 更新と `k in m`
- `set` と内包表記 `set i | i in xs :: i.name`
- **データ構造の性質を `lemma` で証明する** (`forall`、帰納法は自動)

## 実行

```sh
dafny run data.dfy            # または dafny run --target:js data.dfy
```

## 期待される出力

```
Dafny program verifier finished with 10 verified, 0 errors
(1 + 2) * 4 = 12
total: 700
in stock: 2
find bread: Option.Some(Item.Item("bread", 200, 2, Category.Food))
find milk: Option.None
first: Option.Some(['a', 'p', 'p', 'l', 'e'])
by category: map[Category.Food := 700, Category.Tool := 0]
names: {['a', 'p', 'p', 'l', 'e'], ['b', 'r', 'e', 'a', 'd']}
```

`string` は `seq<char>` なので、`Option` や `set` の中では文字の列として表示される (`--target:js` の場合)。
