#!/usr/bin/env bash
# Rust no_std: ホストで cargo test、組込みターゲットでビルド、04-core は QEMU で実行。
source "$(dirname "$0")/common.sh"
echo "Rust ($(cargo --version 2>/dev/null))"
E="$ROOT/rust-no-std/examples"
run_check "01-hello-world: cargo run" bash -c "cd '$E/01-hello-world' && cargo run --quiet | grep -q 'Hello, World!'"
for n in 02-basics 03-data 05-modules; do
  run_check "$n: cargo test" bash -c "cd '$E/$n' && cargo test --quiet"
  run_check "$n: thumbv7em build" bash -c "cd '$E/$n' && cargo build --quiet --target thumbv7em-none-eabihf"
done
run_check "03-data: cargo test --features alloc" bash -c "cd '$E/03-data' && cargo test --quiet --features alloc"
run_check "05-modules: cargo test --features alloc" bash -c "cd '$E/05-modules' && cargo test --quiet --features alloc"
if command -v qemu-system-arm >/dev/null; then
  run_check "04-core: QEMU run" bash -c "cd '$E/04-core' && timeout 60 cargo run --quiet 2>&1 | grep -q 'Hello from bare metal!'"
else
  echo "  skip 04-core (qemu-system-arm がない)"
fi
summary Rust
