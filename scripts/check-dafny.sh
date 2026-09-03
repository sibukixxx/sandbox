#!/usr/bin/env bash
# Dafny: 全 .dfy を verify し、Main を持つものは run (--target:js) で実行する。
# DAFNY 環境変数で dafny バイナリの場所を指定できる。
source "$(dirname "$0")/common.sh"
DAFNY="${DAFNY:-dafny}"
export NODE_PATH="${NODE_PATH:-$(npm root -g 2>/dev/null)}"
echo "Dafny ($("$DAFNY" --version 2>/dev/null))"
for d in "$ROOT"/dafny/examples/*/; do
  name=$(basename "$d")
  main=$(ls "$d"/*.dfy | grep -v Geometry.dfy | head -1)   # include されるファイルは除く
  run_check "$name: verify" "$DAFNY" verify "$main"
  run_check "$name: run" bash -c "cd '$d' && '$DAFNY' run --target:js '$main' && rm -f *.cs *.csproj"
done
summary Dafny
