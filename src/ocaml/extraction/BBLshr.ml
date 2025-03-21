open BBCommon
open BBConst
open BBEq
open BBExtract
open BBIte
open BinInt
open BinNat
open BinNums
open CNF
open NBitsDef
open Nat0
open Eqtype
open Seq
open Ssrnat

(** val bit_blast_lshr_int1 :
    generator -> literal list -> (generator * cnf) * word **)

let bit_blast_lshr_int1 g ls =
  ((g, []), (droplsl (joinmsl ls lit_ff)))

(** val bit_blast_lshr_int :
    generator -> word -> coq_N -> (generator * cnf) * word **)

let rec bit_blast_lshr_int g ls = function
| N0 -> ((g, []), ls)
| Npos p ->
  let (a, b) = bit_blast_lshr_int g ls (N.sub (Npos p) (Npos Coq_xH)) in
  let (a0, b0) = a in
  let (a1, b1) = bit_blast_lshr_int1 a0 b in
  let (a2, b2) = a1 in ((a2, (catrev b0 b2)), b1)

(** val bit_blast_lshr_rec :
    generator -> word -> Equality.sort list -> coq_N ->
    (generator * cnf) * word **)

let rec bit_blast_lshr_rec g ls ns i =
  match ns with
  | [] -> ((g, []), ls)
  | ns_hd :: ns_tl ->
    let (p, ls_tl) =
      bit_blast_lshr_rec g ls ns_tl (N.mul i (Npos (Coq_xO Coq_xH)))
    in
    let (g_tl, cs_tl) = p in
    if eq_op lit_eqType ns_hd (Obj.magic lit_tt)
    then let (p0, ls_hd) = bit_blast_lshr_int g_tl ls_tl i in
         let (g_hd, cs_hd) = p0 in ((g_hd, (catrev cs_tl cs_hd)), ls_hd)
    else if eq_op lit_eqType ns_hd (Obj.magic lit_ff)
         then ((g_tl, cs_tl), ls_tl)
         else let (p0, ls_hd) = bit_blast_lshr_int g_tl ls_tl i in
              let (g_hd, cs_hd) = p0 in
              let (p1, ls_ite) =
                bit_blast_ite g_hd (Obj.magic ns_hd) ls_hd ls_tl
              in
              let (g_ite, cs_ite) = p1 in
              ((g_ite, (catrev cs_tl (catrev cs_hd cs_ite))), ls_ite)

(** val bit_blast_lshr :
    generator -> literal list -> literal list -> (generator * cnf) * word **)

let bit_blast_lshr g ls ns =
  if leq (Stdlib.succ (Stdlib.succ 0)) (size ls)
  then let (p, zero_hi) =
         bit_blast_const g
           (from_nat
             (subn (size ns) (Z.to_nat (Z.log2_up (Z.of_nat (size ls))))) 0)
       in
       let (g_zero_hi, cs_zero_hi) = p in
       let (p0, zero) = bit_blast_const g_zero_hi (from_nat (size ls) 0) in
       let (g_zero, cs_zero) = p0 in
       let (p1, ns_hi) =
         bit_blast_extract g_zero (pred (size ns))
           (Z.to_nat (Z.log2_up (Z.of_nat (size ls)))) ns
       in
       let (g_hi, cs_hi) = p1 in
       let (p2, ns_lo) =
         bit_blast_extract g_hi
           (pred (Z.to_nat (Z.log2_up (Z.of_nat (size ls))))) 0 ns
       in
       let (g_lo, cs_lo) = p2 in
       let (p3, l_eq) = bit_blast_eq g_lo ns_hi zero_hi in
       let (g_eq, cs_eq) = p3 in
       let (p4, ls_shr) =
         bit_blast_lshr_rec g_eq ls (Obj.magic ns_lo) (Npos Coq_xH)
       in
       let (g_shr, cs_shr) = p4 in
       let (p5, ls_ite) = bit_blast_ite g_shr l_eq ls_shr zero in
       let (g_ite, cs_ite) = p5 in
       ((g_ite,
       (catrev cs_zero_hi
         (catrev cs_zero
           (catrev cs_hi (catrev cs_lo (catrev cs_eq (catrev cs_shr cs_ite))))))),
       ls_ite)
  else bit_blast_lshr_rec g ls (Obj.magic ns) (Npos Coq_xH)
