// Node から JS バックエンドの出力を呼ぶ。
//   moon build --target js --release
//   node web/run.mjs
import { fib, sum_to } from "../_build/js/release/build/core.js";

console.log("fib(20) =", fib(20));
console.log("sum_to(100) =", sum_to(100));
