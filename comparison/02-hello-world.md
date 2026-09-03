# 02. Hello, World を 7 言語で

## 結論 (一覧表)

| 言語 | エントリポイント | 出力の手段 | 最小ファイル数 | 実行コマンド | 誰が main を呼ぶか |
|---|---|---|---|---|---|
| MoonBit | `fn main { }` | `println` | 3 (`moon.mod`, `moon.pkg`, `main.mbt`) | `moon run cmd/main` | `moon` が生成した WASM / JS のランタイム |
| OxCaml | `let () = ...` (トップレベル) | `print_endline` | 3 (`dune-project`, `dune`, `main.ml`) | `dune exec ./bin/main.exe` | OCaml ランタイム (上から順に評価) |
| Lean 4 | `def main : IO Unit` | `IO.println` | 3 (`lean-toolchain`, `lakefile.toml`, `Main.lean`) | `lake exe hello` | Lean ランタイム。`#eval` ならビルド不要 |
| Quint | なし (`init` / `step`) | なし (REPL / シミュレータのトレース) | 1 (`hello.qnt`) | `quint run hello.qnt` | シミュレータが `init` → `step` を繰り返す |
| Verse | `OnBegin<override>()` | `Print` (Output Log) | 1 (`.verse`) + UEFN プロジェクト | UEFN で Launch Session | ゲームエンジンがデバイスを起動 |
| Dafny | `method Main()` | `print` | 1 (`hello.dfy`) | `dafny run hello.dfy` | 検証 → コンパイル先言語のランタイム |
| Rust no_std | `extern "C" fn main` (自分で用意) | `write(2)` を直接呼ぶ | 2 (`Cargo.toml`, `main.rs`) | `cargo run` | C ランタイム (`crt1.o`) |

## 言語ごとのコード

### MoonBit → [examples](../moonbit/examples/01-hello-world/)

```moonbit
fn main {
  println("Hello, World!")
}
```

`moon.mod` (モジュール) と `moon.pkg` (パッケージ) の 2 層構造。`--target js` でそのまま JS になる。

### OxCaml → [examples](../oxcaml/examples/01-hello-world/)

```ocaml
let () = print_endline "Hello, World!"
```

`main` はない。トップレベルの `let` が上から順に評価される。標準 OCaml とまったく同じ。

### Lean 4 → [examples](../lean/examples/01-hello-world/)

```lean
def main : IO Unit :=
  IO.println "Hello, World!"

#eval 1 + 2   -- ビルドせずにその場で評価
```

`IO Unit` という型が「副作用のある計算」を表す。日常は `#eval` が中心。

### Quint → [examples](../quint/examples/01-hello-world/)

```quint
module hello {
  pure def greeting: str = "Hello, World!"
  var message: str
  action init = message' = ""
  action step = message' = greeting
}
```

print はない。REPL で `greeting` を評価するか、状態機械を `quint run` で動かしてトレースを見る。

### Verse → [examples](../verse/examples/01-hello-world/) (UEFN 未確認)

```verse
hello_world_device := class(creative_device):
    OnBegin<override>()<suspends>:void =
        Print("Hello, World!")
```

デバイス (クラス) を定義し、エンジンが `OnBegin` を呼ぶ。`<suspends>` は「時間をかけてよい」効果。

### Dafny → [examples](../dafny/examples/01-hello-world/)

```dafny
method Main() {
  print "Hello, World!\n";
}
```

実行の前に必ず検証が走る。`--target:py` などで他言語に出力できる。

### Rust (no_std) → [examples](../rust-no-std/examples/01-hello-world/)

```rust
#![no_std]
#![no_main]

#[link(name = "c")]
extern "C" { fn write(fd: i32, buf: *const u8, count: usize) -> isize; }

#[no_mangle]
pub extern "C" fn main(_argc: i32, _argv: *const *const u8) -> i32 {
    const MSG: &[u8] = b"Hello, World!\n";
    unsafe { write(1, MSG.as_ptr(), MSG.len()); }
    0
}

#[panic_handler]
fn panic(_: &core::panic::PanicInfo) -> ! { loop {} }
```

`println!` は std のもの。`no_std` では OS のシステムコールを直接呼び、`panic_handler` も自分で書く。

## 違いはどこから来るか

1. **「誰がプログラムを起動するか」が違う**。OS が起動する言語 (Rust, OCaml, Dafny, MoonBit, Lean) は `main` を持ち、フレームワークが起動する言語 (Verse) はコールバックを持ち、シミュレータが駆動する言語 (Quint) は `init` / `step` を持つ。
2. **「出力」が言語の関心事かどうか**。Quint は仕様を書く言語なので出力がない。Rust no_std は出力を std に任せていたことが露わになる。
3. **設定ファイルの層の数**。MoonBit はモジュール / パッケージの 2 層、OCaml と Lean はプロジェクト / ターゲットの 2 層、Dafny と Quint は 1 ファイルで完結する。

## どれを選ぶか

| こういう人 | この言語 |
|---|---|
| まず「動いた」を最短で見たい | Dafny, Quint (1 ファイル)、MoonBit (`moon new` で即) |
| std が隠していたものを知りたい | Rust no_std |
| エントリポイントの型 (`IO Unit`) から学びたい | Lean 4 |
