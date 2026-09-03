#!/usr/bin/env bash
# Lean: 各 example で lake build (証明も検査される)。実行ファイルがあれば実行。
source "$(dirname "$0")/common.sh"
echo "Lean ($(lean --version 2>/dev/null | head -1))"
for d in "$ROOT"/lean/examples/*/; do
  name=$(basename "$d")
  run_check "$name: lake build" bash -c "cd '$d' && lake build"
  exe=$(grep -A1 'lean_exe' "$d/lakefile.toml" 2>/dev/null | grep name | sed 's/.*"\(.*\)".*/\1/' || true)
  if [ -n "$exe" ]; then
    run_check "$name: lake exe $exe" bash -c "cd '$d' && lake exe $exe"
  fi
done
summary Lean
