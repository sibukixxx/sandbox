# 05. 失敗コンテキストと効果システム

対応サンプル: [`examples/04-core/`](../examples/04-core/)

## 目的

Verse の設計の中心である「失敗」と「効果」を理解する。他の言語にはない考え方で、Verse を学ぶ最大の理由。

## 失敗コンテキスト

Verse には bool を返す比較がない。`X > 0` は「成功すれば X を返し、そうでなければ失敗する式」。
失敗しうる式は **失敗コンテキスト** の中にしか書けない。失敗コンテキストになるのは:

| 構文 | 失敗したとき |
|---|---|
| `if (expr)` | else 側へ |
| `for (X : Xs, expr)` | その要素をスキップ |
| `not expr` | 成功に反転 |
| `expr1 and expr2` | 全体が失敗 |
| `expr1 or expr2` | expr2 を試す |
| `<decides>` 関数の本体 | 関数全体が失敗 |

```verse
if (Q := SafeDiv[10, 3]):      # 成功したら Q に束縛
    Print("{Q}")
```

## 効果指定子

関数の型の一部として「その関数が何をしうるか」を書く。

| 指定子 | 意味 | 呼べる場所 |
|---|---|---|
| `<decides>` | 失敗しうる | 失敗コンテキスト内。`F[...]` で呼ぶ |
| `<transacts>` | 副作用を持つが失敗時にロールバック | `<transacts>` な関数から |
| `<suspends>` | 時間をかけてよい (Sleep, Await) | `<suspends>` な関数から |
| `<computes>` | 純粋 | どこからでも |
| `<varies>` | 純粋だが結果が毎回変わりうる | |

`<decides>` は通常 `<transacts>` と組で使う。失敗時に途中の副作用を巻き戻す必要があるから。

## ロールバック

```verse
TryIncrementIfBelow(Limit:int)<decides><transacts>:void =
    set Count += 1
    Count <= Limit      # 失敗すると set Count += 1 が無かったことになる
```

失敗コンテキスト内の `set` は仮の変更で、コンテキストが失敗すると破棄される。
「試してダメなら元に戻す」をコードで書く必要がない (ソフトウェアトランザクショナルメモリ)。

## 並行実行

`<suspends>` 関数の中では、時間のかかる処理を構造化して並べられる。

| 構文 | 意味 |
|---|---|
| `sync: a; b` | a と b を並行に実行し、両方終わるまで待つ |
| `race: a; b` | 先に終わった方を採用し、他をキャンセル |
| `rush: a; b` | 先に終わった方の結果を返すが、他は続行 |
| `branch: a` | a を開始して待たずに進む |
| `spawn{ a() }` | `<suspends>` でない関数から非同期処理を開始する |

## 他の言語ではこう書く

| 概念 | Verse | 他の言語 |
|---|---|---|
| 失敗しうる関数 | `<decides>` | `Option<T>` / `Result<T, E>` (Rust)、例外 (Java) |
| ロールバック | `<transacts>` 自動 | 手動で復元、または STM (Haskell) |
| 非同期 | `<suspends>` + `sync` / `race` | `async` / `await` + `Promise.all` / `race` |
| 効果を型で追跡 | 効果指定子 | Koka / Effekt の effect system、Haskell の monad |

## 落とし穴

- `<decides>` 関数を丸括弧 `F(...)` で呼ぶとエラー。角括弧 `F[...]`。
- 失敗コンテキストの外で失敗しうる式を書くとエラー (`Mod[X, 2]` を直接 `Print` に渡せない)。
- `<transacts>` でない関数から `set` できるのは、その関数のローカル変数だけ。
- `loop` は `break` しないと無限ループ。`<suspends>` 内で `Sleep` を入れないとフレームを止める。
