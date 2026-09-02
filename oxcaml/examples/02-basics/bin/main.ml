open Basics

let show_opt = function None -> "None" | Some v -> Printf.sprintf "Some %d" v

let () =
  for n = 1 to 15 do
    Printf.printf "%d: %s / %s\n" n (fizzbuzz n) (classify n)
  done;
  Printf.printf "%d %d\n" (area (Circle 2)) (area Point);
  print_endline (show_opt (average_of_two 6 4 2));
  print_endline (show_opt (average_of_two 6 4 0));
  assert (sign 3 = "positive" && sign (-3) = "negative" && sign 0 = "zero");
  print_endline "asserts ok"
