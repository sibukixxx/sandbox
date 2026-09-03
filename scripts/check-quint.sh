#!/usr/bin/env bash
# Quint: 全 .qnt を typecheck。テストがあれば quint test。04-core は不変条件の反例 / 修正版を確認。
source "$(dirname "$0")/common.sh"
echo "Quint ($(quint --version 2>/dev/null))"
E="$ROOT/quint/examples"
for f in "$E"/*/*.qnt; do
  run_check "$(basename "$(dirname "$f")")/$(basename "$f"): typecheck" quint typecheck "$f"
done
run_check "02-basics: test" quint test "$E/02-basics/basics.qnt"
run_check "03-data: test" quint test "$E/03-data/data.qnt"
run_check "05-modules: test" quint test "$E/05-modules/modules.qnt" --main=main
run_check "05-modules: run inv" quint run "$E/05-modules/modules.qnt" --main=main --invariant=inv --max-steps=20
run_check "01-hello-world: run" quint run "$E/01-hello-world/hello.qnt" --max-steps=2 --invariant=countNonNegative
run_check "04-core: buggy violates" bash -c "! quint run '$E/04-core/bank.qnt' --invariant=noNegative --max-steps=10 >/dev/null 2>&1"
run_check "04-core: fixed holds" quint run "$E/04-core/bank.qnt" --main=bankFixed --invariant=noNegative --max-steps=10
run_check "04-core: test" quint test "$E/04-core/bank.qnt"
summary Quint
