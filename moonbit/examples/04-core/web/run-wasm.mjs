// Node から wasm-gc バックエンドの出力を呼ぶ (Node 22 以降は wasm-gc を既定でサポート)。
//   moon build --target wasm-gc --release
//   node web/run-wasm.mjs
import { readFile } from "node:fs/promises";

const bytes = await readFile(new URL("../_build/wasm-gc/release/build/core.wasm", import.meta.url));
const { instance } = await WebAssembly.instantiate(bytes, {
  // MoonBit の wasm-gc 出力は println などで spectest.print_char を要求する
  spectest: { print_char: (c) => process.stdout.write(String.fromCharCode(c)) },
});
console.log("fib(20) =", instance.exports.fib(20));
console.log("sum_to(100) =", instance.exports.sum_to(100));
