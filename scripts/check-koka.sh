#!/usr/bin/env bash
# Koka: 各 example を koka -e で実行し、期待する出力行を確認する。KOKA 環境変数でバイナリを指定できる。
source "$(dirname "$0")/common.sh"
KOKA="${KOKA:-koka}"
echo "Koka ($("$KOKA" --version 2>/dev/null | head -1))"
E="$ROOT/koka/examples"
run_check "01-hello-world" bash -c "cd '$E/01-hello-world' && '$KOKA' -e hello.kk 2>&1 | grep -q 'Hello, World!'"
run_check "02-basics" bash -c "cd '$E/02-basics' && '$KOKA' -e basics.kk 2>&1 | grep -q 'asserts ok'"
run_check "03-data" bash -c "cd '$E/03-data' && '$KOKA' -e data.kk 2>&1 | grep -q 'total: 700'"
run_check "04-core" bash -c "cd '$E/04-core' && '$KOKA' -e effects.kk 2>&1 | grep -q 'counter = 15'"
run_check "05-modules" bash -c "cd '$E/05-modules' && '$KOKA' -i. -e main.kk 2>&1 | grep -q '1.5m = 150cm'"
summary Koka
