type wrapper =
    Bool of bool
  | Char of char
  | Float of float
  | Int of int
  | String of string
  | Sym of string
  | Nil

let rec convert = function
  | `Bool b -> Bool b
  | `Char c -> Char c
  | `Float f -> Float f
  | `Int i -> Int i
  | `String s -> String s
  | `Sym s -> Sym s
  | `Tuple [] -> Nil
  | _ -> failwith "unaccounted for"

let matcher = function
  | Bool b -> print_endline "b"
  | Char c -> print_char c
  | Float f -> print_float f
  | Int i -> print_int i
  | String s -> print_endline "str"
  | Sym s -> print_endline "sym"
  | Nil -> print_endline "empty"

let op f1 f2 n1 n2 =
  match n1, n2 with
  | Int x, Int y -> Int (f1 x y)
  | Int x, Float y -> Float (f2 (float x) y)
  | Float x, Int y -> Float (f2 x (float y))
  | Float x, Float y -> Float (f2 x y)
  | _ -> failwith "invalid num"

let sym_lookup = function
  | `Sym s ->
    (match s with
     | "+" -> op ( + ) ( +. )
     | _ -> failwith "sym fail 2")
  | _ -> failwith "sym fail "

let rec eval_sexp = function
  | Sexp.Cons t ->
    begin
      match t with
      | (Sexp.Atom h)::t ->
        let a = List.map atomizer t in
        List.fold_right (sym_lookup h) a (Int 0)
      | _ -> failwith "cons fail"
    end
  | _ -> failwith "sexp fail"
and atomizer t =
  match t with
  | Sexp.Atom t -> convert t
  | _ -> eval_sexp t

let rec eval = function
  | h::t -> matcher (eval_sexp h); print_endline ""; eval t
  | _ -> ()
