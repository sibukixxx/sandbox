# 02. Hello, World

対応サンプル: [`examples/01-hello-world/`](../examples/01-hello-world/)

## 目的

`dafny verify` (検証) と `dafny run` (検証 + コンパイル + 実行) の 2 段階を体験する。

## 最小コード

```dafny
method Main() {
  print "Hello, World!\n";
}
```

## 実行

```sh
dafny verify hello.dfy
dafny run hello.dfy
dafny run --target:js hello.dfy    # dotnet がない環境。npm i -g bignumber.js が必要
```

期待される出力:

```
Dafny program verifier finished with 0 verified, 0 errors
Hello, World!
```

## 解説

| 要素 | 意味 |
|---|---|
| `method Main()` | エントリポイント。`method` は副作用を持てる手続き |
| `print` | 引数をカンマ区切りで複数渡せる。改行は `\n` で自分で入れる |
| `dafny verify` | 検証だけを行う。「0 verified」は検証すべき仕様が無かったという意味 |
| `dafny run` | 検証 → C# にコンパイル → 実行。検証に失敗すると実行されない |
| `--target:py` / `js` / `go` / `java` | コンパイル先の切り替え。検証済みコードを他言語のプロジェクトに組み込める |

## 他の言語ではこう書く

C# や Java の `Main` と同じ。違いは、実行の前に必ず検証が走ること。

## 落とし穴

- 既定のコンパイル先は C# で、`dotnet` が必要。ない場合は `--target:js` (Node + bignumber.js) か `--target:py`。
- `dafny run` は作業ディレクトリに `*.cs` / `*.csproj` などの生成物を残す。`.gitignore` に入れる。
