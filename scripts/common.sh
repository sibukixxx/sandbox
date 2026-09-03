# 各 check スクリプトから source される共通処理
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export PATH="$HOME/.moon/bin:$HOME/.elan/bin:$HOME/.cargo/bin:$PATH"

pass=0; fail=0
run_check() {  # run_check <name> <command...>
  local name="$1"; shift
  if "$@" > /tmp/check-"$$".log 2>&1; then
    echo "  ok   $name"; pass=$((pass+1))
  else
    echo "  FAIL $name"; sed 's/^/       /' /tmp/check-"$$".log | tail -20; fail=$((fail+1))
  fi
}
summary() {
  echo "$1: $pass passed, $fail failed"
  [ "$fail" -eq 0 ]
}
