import Basics

def main : IO Unit := do
  for n in [1:16] do
    IO.println s!"{n}: {fizzbuzz n} / {classify n}"
  IO.println (describe 5)
  IO.println (toString (averageOfTwo 6 4 2))
  IO.println (toString (averageOfTwo 6 4 0))
  IO.println (toString (safeGet #[10, 20, 30] 1))
  IO.println (toString (safeGet #[10, 20, 30] 9))
