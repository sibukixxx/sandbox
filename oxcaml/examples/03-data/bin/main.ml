open Data

let show_cat = function Food -> "Food" | Tool -> "Tool"

let () =
  let e = Mul (Add (Num 1, Num 2), Num 4) in
  Printf.printf "(1 + 2) * 4 = %d\n" (eval e);
  Printf.printf "total: %d\n" (total_value sample);
  Printf.printf "in stock: %s\n"
    (String.concat ", " (List.map (fun i -> i.name) (in_stock sample)));
  (match find sample "bread" with
   | Some i -> Printf.printf "find bread: qty=%d\n" i.qty
   | None -> print_endline "find bread: none");
  (match first_name sample with
   | Some n -> Printf.printf "first: %s\n" n
   | None -> ());
  CatMap.iter
    (fun c v -> Printf.printf "%s: %d\n" (show_cat c) v)
    (value_by_category sample);
  let lo, hi = price_range sample in
  Printf.printf "price range: %d..%d\n" lo hi
