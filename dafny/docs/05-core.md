# 05. 事前条件・事後条件・ループ不変条件で証明する

対応サンプル: [`examples/04-core/`](../examples/04-core/)

## 目的

Dafny の中心である「仕様を書けば自動で証明される」を、絶対値 → 探索 → 二分探索 → ソートの順に体験する。

## 最小コード

```dafny
method BinarySearch(a: array<int>, key: int) returns (idx: int)
  requires Sorted(a)
  ensures idx >= 0 ==> idx < a.Length && a[idx] == key
  ensures idx < 0 ==> forall k :: 0 <= k < a.Length ==> a[k] != key
{
  var lo, hi := 0, a.Length;
  while lo < hi
    invariant 0 <= lo <= hi <= a.Length
    invariant forall k :: 0 <= k < lo ==> a[k] < key
    invariant forall k :: hi <= k < a.Length ==> a[k] > key
    decreases hi - lo
  {
    var mid := lo + (hi - lo) / 2;
    if a[mid] < key { lo := mid + 1; }
    else if a[mid] > key { hi := mid; }
    else { return mid; }
  }
  return -1;
}
```

## 解説

### 3 つの契約

| キーワード | 誰の義務か | 検証されること |
|---|---|---|
| `requires P` | 呼び出し側 | 呼び出し箇所で P が成り立つ |
| `ensures Q` | 実装側 | 全ての実行経路の終わりで Q が成り立つ |
| `invariant I` | ループ | ループ開始時に I、各周回後も I |

Z3 は「`requires` を仮定して本体を実行すると `ensures` が成り立つか」を全ての入力について確認する。テストと違い、特定の入力ではなく **全て** の入力。

### ループ不変条件の見つけ方

ループ後に証明したいこと (`ensures`) を、「ループの途中まで」に言い換える。

- 線形探索: `ensures` は「全範囲に key がない」→ invariant は「idx より左に key がない」
- 二分探索: 「lo より左は全部 key より小さい」「hi 以降は全部大きい」
- 挿入ソート: 「先頭 i 個はソート済み」、内側は「j 以外はソート済み」「a[j] は j より右の全てより小さい」

不変条件が足りないと `ensures` が証明できず、多すぎると不変条件自体が保てない。サンプルの README にある「1 行消してみる」で感覚が掴める。

### decreases

ループが必ず終わることの証明。毎周回で減る量を書く。単純なカウンタなら自動で見つかる。

### predicate / lemma

- `predicate Sorted(a)`: bool を返す関数。仕様に名前を付ける。`reads a` で読む対象を宣言する
- `lemma`: 実行されない method。仕様間の関係 (「ソート済みなら先頭が最小」など) を証明しておき、他の method から呼んで Z3 を助ける

### modifies と old

配列を書き換える method は `modifies a` が必要。`old(a[..])` で呼び出し前の値を参照でき、`multiset(a[..]) == multiset(old(a[..]))` で「並べ替えただけ」を表す。

### 検証が失敗したときの読み方

```
Error: a postcondition could not be proved on this return path
Error: this loop invariant could not be proved on entry
Error: index out of range
```

- `postcondition` → `ensures` が証明できない。不変条件が足りないことが多い
- `invariant ... on entry` → ループ開始時点で不変条件が偽。初期値を確認
- `invariant ... maintained` → 周回で不変条件が破れる。不変条件が強すぎる
- `index out of range` → 添字の範囲が仕様から分からない。`0 <= i < a.Length` を invariant や requires に足す

## 他の言語ではこう書く

Lean で同じことをすると、帰納法を tactic で書く必要がある。Dafny はそれを Z3 に任せる代わりに、Z3 が解ける形に仕様を整える工夫が要る。
Rust の `debug_assert!` は実行時に特定の入力を検査するが、Dafny の `ensures` はコンパイル時に全入力を検査する。

## 落とし穴

- 検証時間が長いときは `assert` で中間の性質を明示すると Z3 のヒントになる。
- `forall` に添字が入る場合、範囲 (`0 <= k < a.Length`) を必ず書かないと `index out of range` になる。
- 非線形算術 (`x * y`) は Z3 が苦手。`lemma` で分けるか、`{:nonlinear}` を検討する。
