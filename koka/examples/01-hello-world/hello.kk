// Koka の Hello, World。
// 関数の型に「効果」が付く。println は console 効果を持つので、main も console を持つ。
// 効果は推論されるので書かなくてよいが、明示すると `fun main() : console ()` になる。
fun main()
  println("Hello, World!")
