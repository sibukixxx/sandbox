#!/usr/bin/env bash
# MoonBit: 各 example で moon check && moon test。04-core は JS / wasm-gc ビルドと Node からの呼び出しも確認。
source "$(dirname "$0")/common.sh"
echo "MoonBit ($(moon version 2>/dev/null | head -1))"
for d in "$ROOT"/moonbit/examples/*/; do
  name=$(basename "$d")
  run_check "$name: moon check" bash -c "cd '$d' && moon check"
  run_check "$name: moon test" bash -c "cd '$d' && moon test"
done
d="$ROOT/moonbit/examples/04-core"
run_check "04-core: moon test --target js" bash -c "cd '$d' && moon test --target js"
run_check "04-core: build js + node" bash -c "cd '$d' && moon build --target js --release && node web/run.mjs | grep -q 'fib(20) = 6765'"
run_check "04-core: build wasm-gc + node" bash -c "cd '$d' && moon build --target wasm-gc --release && node web/run-wasm.mjs | grep -q 'sum_to(100) = 5050'"
summary MoonBit
