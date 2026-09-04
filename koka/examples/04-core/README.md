# 04 代数的効果とハンドラ

## 学ぶこと

- `effect` で操作を宣言する (`fun` = 再開のみ、`ctl` = 継続 `resume` を自由に扱える)
- 関数の型に効果が現れる: `: <log, raise> int`
- `with fun ... / with ctl ...` でハンドラを当てる。**同じ関数に違うハンドラ** を当てると振る舞いが変わる
- `raise` を「例外」(resume しない) にも「回復」(resume する) にもできる
- `state` 効果で可変状態を、`choose` 効果で非決定性 (resume を複数回) を表す

## 実行

```sh
koka -e effects.kk
```

## 期待される出力

```
[log] div 10 / 2
5
-1
Nothing logs=["div 7 / 0"]
counter = 15
[(3,4,5)]
```
