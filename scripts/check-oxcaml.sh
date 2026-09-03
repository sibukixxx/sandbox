#!/usr/bin/env bash
# OxCaml: OxCaml switch があれば dune build && dune exec。なければ標準 ocamlopt で章 2〜4, 6 だけ確認する。
# 04-core (モード / unboxed 型) は OxCaml switch がないとスキップ。
source "$(dirname "$0")/common.sh"
HAVE_OX=0
if command -v opam >/dev/null && opam switch list 2>/dev/null | grep -q '5.2.0+ox'; then
  eval "$(opam env --switch 5.2.0+ox --set-switch)"; HAVE_OX=1
fi
echo "OxCaml (ocaml $(ocamlopt -version 2>/dev/null || echo none), oxcaml switch: $HAVE_OX)"
check_with_ocamlopt() {  # 標準 OCaml で bin/*.ml (と lib/*.ml) を直接コンパイルして実行する
  local d="$1" tmp; tmp=$(mktemp -d)
  if [ -d "$d/lib" ]; then
    cp "$d"/lib/*.ml "$tmp/"; sed 's/^open Geometry$//' "$d/bin/main.ml" > "$tmp/main.ml"
    (cd "$tmp" && ocamlopt shape.ml shapes.ml units.ml main.ml -o m >/dev/null && ./m)
  else
    cp "$d"/bin/*.ml "$tmp/"
    (cd "$tmp" && ocamlopt $(ls *.ml | grep -v main.ml) main.ml -o m >/dev/null && ./m)
  fi
}
for d in "$ROOT"/oxcaml/examples/*/; do
  name=$(basename "$d")
  if [ "$HAVE_OX" = 1 ] && command -v dune >/dev/null; then
    run_check "$name: dune build && exec" bash -c "cd '$d' && dune build 2>&1 && dune exec ./bin/main.exe"
  elif [ "$name" = "04-core" ]; then
    echo "  skip $name (OxCaml switch が必要)"
  else
    run_check "$name: ocamlopt" check_with_ocamlopt "$d"
  fi
done
summary OxCaml
