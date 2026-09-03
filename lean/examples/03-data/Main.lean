import Data

def main : IO Unit := do
  let e := Expr.mul (.add (.num 1) (.num 2)) (.num 4)
  IO.println s!"(1 + 2) * 4 = {e.eval}"
  IO.println s!"total: {totalValue sample}"
  IO.println s!"in stock: {(inStock sample).map (·.name)}"
  IO.println s!"find bread: {repr (find sample "bread")}"
  IO.println s!"by category: {repr (valueByCategory sample)}"
