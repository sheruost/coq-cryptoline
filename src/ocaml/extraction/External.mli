open Datatypes
open BinNums
open CNF
open NBitsDef
open Poly
open Ring_polynom

val nat_of_z : Z.t -> nat
val z_of_nat : nat -> Z.t
val bits_of_z : int -> Z.t -> bits
val z_of_pos : positive -> Z.t
val pos_of_z : Z.t -> positive
val coq_z_of_z : Z.t -> coq_Z
val z_of_coq_z : coq_Z -> Z.t

val ext_all_unsat_impl : cnf list -> bool

val ext_find_coefficients_impl : coq_Z coq_PExpr list -> coq_Z coq_PExpr -> coq_Z coq_PExpr -> (coq_Z coq_PExpr) list * coq_Z coq_PExpr
