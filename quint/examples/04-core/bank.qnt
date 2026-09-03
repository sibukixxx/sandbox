// 状態機械のシミュレーションと不変条件の検査。
// 題材: 銀行口座。「残高は負にならない」を不変条件として検査する。
//
//   quint run bank.qnt --invariant=noNegative        → バグ入りの withdraw で反例が出る
//   quint run bank.qnt --invariant=noNegative --main=bankFixed → 修正版は違反なし

module bank {
  // 口座の集合 (有限にするのがモデル検査の基本)
  pure val ACCOUNTS = Set("alice", "bob")

  // 状態変数: 口座 → 残高
  var balances: str -> int

  // 初期状態
  action init = balances' = ACCOUNTS.mapBy(_ => 0)

  // 入金: どの口座にいくら入れるかは非決定的 (nondet) に選ぶ
  action deposit = {
    nondet who = oneOf(ACCOUNTS)
    nondet amount = oneOf(1.to(10))
    balances' = balances.setBy(who, b => b + amount)
  }

  // 出金 (バグあり): 残高チェックを忘れている
  action withdraw = {
    nondet who = oneOf(ACCOUNTS)
    nondet amount = oneOf(1.to(10))
    balances' = balances.setBy(who, b => b - amount)
  }

  // 送金: 2 つの口座を同時に更新する
  action transfer = {
    nondet from = oneOf(ACCOUNTS)
    nondet dest = oneOf(ACCOUNTS.exclude(Set(from)))   // `to` は組込み名なので使えない
    nondet amount = oneOf(1.to(10))
    all {
      balances.get(from) >= amount,            // 前提条件 (false ならこの action は選ばれない)
      balances' = balances
        .setBy(from, b => b - amount)
        .setBy(dest, b => b + amount),
    }
  }

  // 1 ステップ = いずれかの action (any は非決定的な選択)
  action step = any { deposit, withdraw, transfer }

  // --- 不変条件 (val): すべての到達可能な状態で成り立ってほしい性質 ---

  // 残高は負にならない ... withdraw のバグで破れる
  val noNegative = ACCOUNTS.forall(a => balances.get(a) >= 0)

  // 総額は入出金でしか変わらない (transfer では保存される) ... これは常に成り立つ
  // (状態 1 つでは書けないので、ここでは「型が合っている」ことだけ確認)
  val totalDefined = balances.keys() == ACCOUNTS

  // --- テスト: 特定のシナリオを run で書く ---
  run transferTest =
    init
      .then(all { balances' = balances.setBy("alice", _ => 10) })   // alice に 10
      .then(transfer)                                                // 誰かが送金
      .then(all {
        assert(balances.get("alice") + balances.get("bob") == 10),   // 総額は保存
        balances' = balances,
      })
}

// 修正版: withdraw に残高チェックを入れる。
// `import bank.*` だと init / step が衝突するので、名前空間付きで import する
module bankFixed {
  import bank as b

  action withdrawSafe = {
    nondet who = oneOf(b::ACCOUNTS)
    nondet amount = oneOf(1.to(10))
    all {
      b::balances.get(who) >= amount,
      b::balances' = b::balances.setBy(who, bal => bal - amount),
    }
  }

  action init = b::init
  action step = any { b::deposit, withdrawSafe, b::transfer }
  val noNegative = b::noNegative
}
