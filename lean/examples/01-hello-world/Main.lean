/-- エントリポイント。`IO Unit` は「副作用を伴い、値を返さない計算」という型。 -/
def main : IO Unit :=
  IO.println "Hello, World!"

-- `#eval` はエディタ / `lean Main.lean` でその場で評価する。ビルド不要。
#eval "Hello from #eval"
#eval 1 + 2
