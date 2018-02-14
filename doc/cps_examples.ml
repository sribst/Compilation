(** * CPS conversion via examples *)

(** NB: some parts below needs ocaml -rectypes *)

(** CPS : continuation-passing-style, i.e. any function
    will receive an extra argument, a continuation, which is
    a function launched when the current function is done.
    In particular, a code converted to CPS is tail-recursive. *)

(***************************************************************)

(** FIRST EXAMPLE : fact *)

(** Initial code, not tail-recursive *)

let rec fact n =
  if n = 0 then 1
  else fact (n-1) * n

let _ = fact 10

(** First CPS version, using nested anonymous functions
    (ok in OCaml, but not in Fopix nor Javix) *)

let rec fact n k =
  if n = 0 then k 1
  else fact (n-1) (fun r -> k (r*n))

let _ = fact 10 (fun r -> r) (** initial continuation : identity *)

(** Flattened CPS code : no nested anonymous functions anymore,
    but we still need some partial applications to propagate the value
    of some variables right into the body of the created continuation.
    (OCaml : ok, but still not Fopix-compatible nor Javix) *)

let rec fact n k =
  if n = 0 then k 1
  else fact (n-1) (kont k n)

and kont k n r = k (r*n)

let _ = fact 10 (fun r -> r)

(** First-order CPS : we regroup the propagated variables into
    a tuple, named "environment". Then, for consistency, all
    functions and continuations take an extra environment arg.

    In practice, an env is a tuple, with a continuation in the
    first place, an older env in second place, and optionally
    some other needed variables after that.

    NB: this code is ill-typed in OCaml unless the -rectypes
    option is used, since we'll have tuples inside tuples.
*)

let rec fact n k e =
  if n = 0 then k 1 e
  else fact (n-1) kont (k,e,n)

and kont r (k,e,n) = k (r*n) e

(** A empty environment of the right type (thanks to OCaml cyclic values).
    Will never be accessed, so the details aren't important.
    It could also be (Obj.magic ()), and should be so in Jakix *)
let rec init_env = ((fun _ _ -> 0), init_env, 0)

let _ = fact 10 (fun x _ -> x) init_env


(** First-Order CPS with well-typed environment.
    If we really want, we could define a type of environment
    that pleases the OCaml standard typechecker.
    But that's irrelevent for Fopix and Javix. *)

type env =
  | InitialEnv
  | PushEnv of cont * env * int

and cont = int -> env -> int

let rec fact n k e =
 if n = 0 then k 1 e
 else fact (n-1) kont (PushEnv (k,e,n))

and kont r e = match e with
  | PushEnv (k,e,n) -> k (r*n) e
  | InitialEnv -> assert false

let _ = fact 10 (fun x _ -> x) InitialEnv


(***************************************************************)

(** SECOND EXAMPLE : fibonacci *)

(** This will lead to two generated continuations *)

let rec fib n = if n <= 1 then 1 else fib (n-1) + fib (n-2)

let _ = fib 10

(** First CPS version, using nested anonymous functions *)

let rec fib n k =
  if n <= 1 then k 1
  else
    fib (n-1)
        (fun r -> fib (n-2)
                      (fun r' -> k (r+r')))

let _ = fib 10 (fun r -> r)

(** Flattened CPS code, with partial application *)

let rec fib n k =
  if n <= 1 then k 1
  else fib (n-1) (kont1 k n)

and kont1 k n r = fib (n-2) (kont2 k r)

and kont2 k r r' = k (r+r')

let _ = fib 10 (fun r -> r)

(** First-order CPS *)

let rec fib n k e =
  if n <= 1 then k 1 e
  else fib (n-1) kont1 (k,e,n)

and kont1 r (k,e,n) = fib (n-2) kont2 (k,e,r)

and kont2 r' (k,e,r) = k (r+r') e

let _ = fib 10 (fun x _ -> x) init_env;;


(***************************************************************)

(** THIRD EXAMPLE : some nested function calls *)

let rec g n = if n = 0 then 0 else n - g (g (n-1))
let _ = g 10

(** CPS with nested anonymous functions *)

let rec g n k =
 if n = 0 then k 0
 else g (n-1) (fun r -> g r (fun r' -> k (n - r')))

let _ = g 10 (fun x -> x)

(** CPS with 1st order functions *)

let rec g n k e =
 if n = 0 then k 0 e
 else g (n-1) kont1 (k,e,n)
and kont1 r (k,e,n) = g r kont2 (k,e,n)
and kont2 r (k,e,n) = k (n-r) e

let _ = g 10 (fun x _ -> x) init_env

(** NB : all our examples above use a ternary env
    (1 cont + 1 saved env + 1 saved var), but the number
    of saved variables may vary. *)
