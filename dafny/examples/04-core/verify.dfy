// 事前条件・事後条件・ループ不変条件で証明する。
// 題材: 絶対値 → 線形探索 → 二分探索 → 挿入ソート。
// すべて `dafny verify verify.dfy` で自動証明される。

// ---- 1. 事後条件 (ensures) ----
// 「返り値について常に成り立つこと」を書くと、Z3 が全ての入力について確認する
method Abs(x: int) returns (r: int)
  ensures r >= 0
  ensures r == x || r == -x
{
  if x < 0 { r := -x; } else { r := x; }
}

// ---- 2. 事前条件 (requires) ----
// 呼び出し側の義務。守らない呼び出しは検証エラー (実行前に分かる)
method Div(a: int, b: int) returns (q: int)
  requires b != 0
  ensures q == a / b
{
  q := a / b;
}

// ---- 3. ループ不変条件 (invariant) ----
// while には「毎周回の前後で成り立つこと」を書く。これが無いとループ後の性質を証明できない。
// 線形探索: 見つかれば添字、なければ -1
method Find(a: array<int>, key: int) returns (idx: int)
  ensures idx >= 0 ==> idx < a.Length && a[idx] == key       // 見つかった場合
  ensures idx < 0 ==> forall k :: 0 <= k < a.Length ==> a[k] != key   // 見つからない場合
{
  idx := 0;
  while idx < a.Length
    invariant 0 <= idx <= a.Length
    invariant forall k :: 0 <= k < idx ==> a[k] != key   // ここまで見た範囲に key はない
  {
    if a[idx] == key { return; }
    idx := idx + 1;
  }
  idx := -1;
}

// ---- 4. 二分探索 ----
// 「ソート済み」を述語 (predicate) として定義し、事前条件に使う
predicate Sorted(a: array<int>)
  reads a
{
  forall i, j :: 0 <= i < j < a.Length ==> a[i] <= a[j]
}

method BinarySearch(a: array<int>, key: int) returns (idx: int)
  requires Sorted(a)
  ensures idx >= 0 ==> idx < a.Length && a[idx] == key
  ensures idx < 0 ==> forall k :: 0 <= k < a.Length ==> a[k] != key
{
  var lo, hi := 0, a.Length;
  while lo < hi
    invariant 0 <= lo <= hi <= a.Length
    invariant forall k :: 0 <= k < lo ==> a[k] < key        // lo より左は全部小さい
    invariant forall k :: hi <= k < a.Length ==> a[k] > key // hi 以降は全部大きい
    decreases hi - lo                                        // 停止性: 毎回縮む
  {
    var mid := lo + (hi - lo) / 2;
    if a[mid] < key {
      lo := mid + 1;
    } else if a[mid] > key {
      hi := mid;
    } else {
      return mid;
    }
  }
  return -1;
}

// ---- 5. 配列を書き換える: modifies と old ----
// 挿入ソート。書き換える配列を modifies に書き、old(a[..]) で変更前の値を参照する
method InsertionSort(a: array<int>)
  modifies a
  ensures Sorted(a)
  ensures multiset(a[..]) == multiset(old(a[..]))   // 要素の多重集合は変わらない (並べ替えただけ)
{
  if a.Length == 0 { return; }
  var i := 1;
  while i < a.Length
    invariant 1 <= i <= a.Length
    invariant forall p, q :: 0 <= p < q < i ==> a[p] <= a[q]   // 先頭 i 個はソート済み
    invariant multiset(a[..]) == multiset(old(a[..]))
  {
    var j := i;
    // a[j] を左へ動かしていく。「j 以外はソート済み」「a[j] は j より右の全てより小さい」を保つ
    while j > 0 && a[j - 1] > a[j]
      invariant 0 <= j <= i
      invariant forall p, q :: 0 <= p < q <= i && q != j ==> a[p] <= a[q]
      invariant forall q :: j < q <= i ==> a[j] <= a[q]
      invariant multiset(a[..]) == multiset(old(a[..]))
    {
      a[j - 1], a[j] := a[j], a[j - 1];
      j := j - 1;
    }
    i := i + 1;
  }
}

// ---- 6. lemma: 実行されない証明 ----
// 「ソート済み配列の先頭は最小」を lemma として証明しておくと、他の method から使える
lemma SortedFirstIsMin(a: array<int>)
  requires Sorted(a) && a.Length > 0
  ensures forall k :: 0 <= k < a.Length ==> a[0] <= a[k]
{
  // Sorted の定義から自動で導かれる
}

method Main() {
  var a := new int[6];
  a[0], a[1], a[2], a[3], a[4], a[5] := 5, 2, 9, 1, 5, 6;
  InsertionSort(a);
  print a[..], "\n";
  var i := BinarySearch(a, 9);
  print "index of 9: ", i, "\n";
  i := BinarySearch(a, 4);
  print "index of 4: ", i, "\n";
  var r := Abs(-7);
  print "abs(-7) = ", r, "\n";
  // var q := Div(1, 0);   // 検証エラー: precondition could not be proved
}
