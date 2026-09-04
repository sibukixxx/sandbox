#!/usr/bin/env bash
# Gleam: 各 example で gleam build / run / test。Erlang/OTP 27 以上と escript が PATH に必要。
source "$(dirname "$0")/common.sh"
echo "Gleam ($(gleam --version 2>/dev/null), OTP $(erl -noshell -eval 'io:format("~s",[erlang:system_info(otp_release)]), halt().' 2>/dev/null))"
E="$ROOT/gleam/examples"
run_check "01-hello-world: run" bash -c "cd '$E/01-hello-world' && gleam run | grep -q 'Hello, World!'"
run_check "01-hello-world: run --target javascript" bash -c "cd '$E/01-hello-world' && gleam run --target javascript | grep -q 'Hello, World!'"
for n in 02-basics 03-data 04-core; do
  run_check "$n: run" bash -c "cd '$E/$n' && gleam run >/dev/null"
  run_check "$n: test" bash -c "cd '$E/$n' && gleam test"
done
run_check "05-modules: run" bash -c "cd '$E/05-modules' && gleam run | grep -q 'negative length'"
summary Gleam
