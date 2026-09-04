#!/usr/bin/env bash
# Zig: 単一ファイルの example は zig run + zig test、build.zig のある example は zig build run / test。
source "$(dirname "$0")/common.sh"
echo "Zig ($(zig version 2>/dev/null))"
E="$ROOT/zig/examples"
run_check "01-hello-world: run" bash -c "cd '$E/01-hello-world' && zig run hello.zig | grep -q 'Hello, World!'"
for n in 02-basics:basics 03-data:data 04-core:comptime; do
  d=${n%%:*}; f=${n##*:}
  run_check "$d: zig run" bash -c "cd '$E/$d' && zig run $f.zig >/dev/null"
  run_check "$d: zig test" bash -c "cd '$E/$d' && zig test $f.zig"
done
run_check "05-modules: zig build run" bash -c "cd '$E/05-modules' && zig build run | grep -q 'total:  5.1416'"
run_check "05-modules: zig build test" bash -c "cd '$E/05-modules' && zig build test"
summary Zig
