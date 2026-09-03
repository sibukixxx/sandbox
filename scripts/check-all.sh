#!/usr/bin/env bash
# 全言語の check を順に実行する (Verse は対象外)。
cd "$(dirname "$0")"
status=0
for lang in moonbit oxcaml lean quint dafny rust-no-std; do
  ./check-$lang.sh || status=1
  echo
done
exit $status
