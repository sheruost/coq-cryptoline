open Datatypes
open NBitsDef
open PeanoNat
open Eqtype
open Seq
open Ssrnat

(** val extzip : 'a1 -> 'a2 -> 'a1 list -> 'a2 list -> ('a1 * 'a2) list **)

let rec extzip sd td ss ts =
  match ss with
  | [] ->
    (match ts with
     | [] -> zip ss (nseq (size ss) td)
     | _ :: _ -> zip (nseq (size ts) sd) ts)
  | s :: ss0 ->
    (match ts with
     | [] -> zip ss (nseq (size ss) td)
     | t :: ts0 -> (s, t) :: (extzip sd td ss0 ts0))

(** val lift :
    'a1 -> ('a1 -> 'a1 -> 'a1) -> 'a1 list -> 'a1 list -> 'a1 list **)

let lift d op ss ts =
  map (fun e -> op (fst e) (snd e)) (extzip d d ss ts)

(** val lift0 :
    (bool -> bool -> bool) -> bool list -> bool list -> bool list **)

let lift0 =
  lift b0

(** val extzip0 : bool list -> bool list -> (bool * bool) list **)

let extzip0 =
  extzip b0 b0

(** val succB : bits -> bits **)

let rec succB = function
| [] -> []
| hd :: tl -> if hd then b0 :: (succB tl) else b1 :: tl

(** val andB : bits -> bits -> bits **)

let andB bs1 bs2 =
  lift0 (&&) bs1 bs2

(** val orB : bits -> bits -> bits **)

let orB bs1 bs2 =
  lift0 (||) bs1 bs2

(** val xorB : bits -> bits -> bits **)

let xorB bs1 bs2 =
  lift0 xorb bs1 bs2

(** val negB : bits -> bits **)

let negB bs =
  succB (invB bs)

(** val orb_all : bits -> bool **)

let rec orb_all = function
| [] -> false
| hd :: tl -> let result_tl = orb_all tl in (||) result_tl hd

(** val andb_orb_all_zip : (bool * bool) list -> bool **)

let rec andb_orb_all_zip bsp = match bsp with
| [] -> false
| p :: bsp_tl ->
  let (_, ls2_high) = p in
  let result_tl = andb_orb_all_zip bsp_tl in
  let result_or = orb_all (unzip1 bsp) in
  (||) result_tl ((&&) result_or ls2_high)

(** val andb_orb_all : bits -> bits -> bool **)

let andb_orb_all bs1 bs2 =
  andb_orb_all_zip (extzip0 bs1 (rev bs2))

(** val bool_adder : bool -> bool -> bool -> bool * bool **)

let bool_adder c b2 b3 =
  if c
  then if b2
       then if b3 then (true, true) else (true, false)
       else if b3 then (true, false) else (false, true)
  else if b2
       then if b3 then (true, false) else (false, true)
       else if b3 then (false, true) else (false, false)

(** val full_adder_zip : bool -> (bool * bool) list -> bool * bits **)

let rec full_adder_zip c = function
| [] -> (c, [])
| p :: tl ->
  let (hd1, hd2) = p in
  let (c0, hd) = bool_adder c hd1 hd2 in
  let (c1, tl0) = full_adder_zip c0 tl in (c1, (hd :: tl0))

(** val full_adder : bool -> bits -> bits -> bool * bits **)

let full_adder c bs1 bs2 =
  full_adder_zip c (zip bs1 bs2)

(** val adcB : bool -> bits -> bits -> bool * bits **)

let adcB =
  full_adder

(** val addB : bits -> bits -> bits **)

let addB bs1 bs2 =
  snd (adcB false bs1 bs2)

(** val carry_addB : bits -> bits -> bool **)

let carry_addB bs1 bs2 =
  fst (adcB false bs1 bs2)

(** val coq_Uaddo : bits -> bits -> bool **)

let coq_Uaddo =
  carry_addB

(** val sbbB : bool -> bits -> bits -> bool * bits **)

let sbbB b bs1 bs2 =
  let (c, res) = adcB (negb b) bs1 (invB bs2) in ((negb c), res)

(** val subB : bits -> bits -> bits **)

let subB bs1 bs2 =
  snd (sbbB false bs1 bs2)

(** val borrow_subB : bits -> bits -> bool **)

let borrow_subB bs1 bs2 =
  fst (sbbB false bs1 bs2)

(** val coq_Saddo : bits -> bits -> bool **)

let coq_Saddo bs1 bs2 =
  let sign1 = snd (splitmsb bs1) in
  let sign2 = snd (splitmsb bs2) in
  let b_add = addB bs1 bs2 in
  let sign_fa = snd (splitmsb b_add) in
  (||) ((&&) ((&&) sign1 sign2) (negb sign_fa))
    ((&&) ((&&) (negb sign1) (negb sign2)) sign_fa)

(** val coq_Ssubo : bits -> bits -> bool **)

let coq_Ssubo bs1 bs2 =
  let sign1 = snd (splitmsb bs1) in
  let sign2 = snd (splitmsb bs2) in
  let b_sub = subB bs1 bs2 in
  let sign_sub = snd (splitmsb b_sub) in
  (||) ((&&) ((&&) (negb sign1) sign2) sign_sub)
    ((&&) ((&&) sign1 (negb sign2)) (negb sign_sub))

(** val full_mul : bits -> bits -> bits **)

let rec full_mul bs1 bs2 =
  match bs1 with
  | [] -> from_nat (addn (size bs1) (size bs2)) 0
  | hd :: tl ->
    if hd
    then addB (joinlsb false (full_mul tl bs2)) (zext (size bs1) bs2)
    else joinlsb false (full_mul tl bs2)

(** val mulB : bits -> bits -> bits **)

let mulB bs1 bs2 =
  low (size bs1) (full_mul bs1 bs2)

(** val coq_Umulo : bits -> bits -> bool **)

let coq_Umulo bs1 bs2 =
  let bs1_hightl = snd (splitlsb bs1) in
  let bs2_hightl = snd (splitlsb bs2) in
  let wbs1 = zext (Stdlib.succ 0) bs1 in
  let wbs2 = zext (Stdlib.succ 0) bs2 in
  let mul = mulB wbs1 wbs2 in
  let mul_high = msb mul in (||) (andb_orb_all bs1_hightl bs2_hightl) mul_high

(** val coq_Smulo : bits -> bits -> bool **)

let coq_Smulo bs1 bs2 =
  let bs1_tl = fst (splitmsb bs1) in
  let bs1_sign = snd (splitmsb bs1) in
  let bs2_tl = fst (splitmsb bs2) in
  let bs2_sign = snd (splitmsb bs2) in
  let wsign1 = nseq (size bs1_tl) bs1_sign in
  let wsign2 = nseq (size bs2_tl) bs2_sign in
  let xbs1 = xorB bs1_tl wsign1 in
  let xbs2 = xorB bs2_tl wsign2 in
  let xbs1_hightl = snd (splitlsb xbs1) in
  let xbs2_hightl = snd (splitlsb xbs2) in
  let and_or = andb_orb_all xbs1_hightl xbs2_hightl in
  let wbs1 = sext (Stdlib.succ 0) bs1 in
  let wbs2 = sext (Stdlib.succ 0) bs2 in
  let mul = mulB wbs1 wbs2 in
  let mul_tl = fst (splitmsb mul) in
  let mul_n = snd (splitmsb mul) in
  let mul_n_minus1 = snd (splitmsb mul_tl) in
  (||) and_or (xorb mul_n mul_n_minus1)

(** val ltB_lsb_zip : (bool * bool) list -> bool **)

let rec ltB_lsb_zip = function
| [] -> false
| p :: tl ->
  let (hd1, hd2) = p in
  (||)
    ((&&)
      ((&&)
        (eq_op (seq_eqType bool_eqType) (Obj.magic unzip1 tl)
          (Obj.magic unzip2 tl)) (negb hd1)) hd2) (ltB_lsb_zip tl)

(** val ltB_lsb : bits -> bits -> bool **)

let ltB_lsb bs1 bs2 =
  ltB_lsb_zip (extzip0 bs1 bs2)

(** val leB : bits -> bits -> bool **)

let leB bs1 bs2 =
  (||) (eq_op bitseq_eqType (Obj.magic bs1) (Obj.magic bs2)) (ltB_lsb bs1 bs2)

(** val gtB : bits -> bits -> bool **)

let gtB bs1 bs2 =
  ltB_lsb bs2 bs1

(** val geB : bits -> bits -> bool **)

let geB bs1 bs2 =
  leB bs2 bs1

(** val sltB : bits -> bits -> bool **)

let sltB bs1 bs2 =
  let tbs1 = fst (splitmsb bs1) in
  let sign1 = snd (splitmsb bs1) in
  let tbs2 = fst (splitmsb bs2) in
  let sign2 = snd (splitmsb bs2) in
  let ult_tl = ltB_lsb tbs1 tbs2 in
  (||) ((&&) (eq_op bool_eqType (Obj.magic sign1) (Obj.magic sign2)) ult_tl)
    ((&&) sign1 (negb sign2))

(** val sleB : bits -> bits -> bool **)

let sleB bs1 bs2 =
  (||) (eq_op bitseq_eqType (Obj.magic bs1) (Obj.magic bs2)) (sltB bs1 bs2)

(** val sgtB : bits -> bits -> bool **)

let sgtB bs1 bs2 =
  sltB bs2 bs1

(** val sgeB : bits -> bits -> bool **)

let sgeB bs1 bs2 =
  sleB bs2 bs1

(** val rolB1 : bits -> bits **)

let rolB1 bs =
  dropmsb (joinlsb (msb bs) bs)

(** val rolB : int -> bits -> bits **)

let rolB n bs =
  iter n rolB1 bs

(** val rorB1 : bits -> bits **)

let rorB1 bs =
  droplsb (joinmsb bs (lsb bs))

(** val rorB : int -> bits -> bits **)

let rorB n bs =
  iter n rorB1 bs

(** val shrB1 : bits -> bits **)

let shrB1 bs =
  droplsb (joinmsb bs b0)

(** val shrB : int -> bits -> bits **)

let shrB n bs =
  iter n shrB1 bs

(** val shrBB : bits -> bits -> bits **)

let shrBB bs ns =
  let szbs = size bs in
  let szns = size ns in
  let log2szbs = Nat.log2_up szbs in
  if leq szbs (Stdlib.succ 0)
  then if eq_op bitseq_eqType (Obj.magic ns) (Obj.magic zeros szns)
       then bs
       else zeros szbs
  else if leq szns log2szbs
       then shrB (to_nat ns) bs
       else let zero_hi = zeros (subn szns log2szbs) in
            let ns_hi = high (subn szns log2szbs) ns in
            if eq_op bitseq_eqType (Obj.magic ns_hi) (Obj.magic zero_hi)
            then let ns_lo = low log2szbs ns in shrB (to_nat ns_lo) bs
            else from_nat szbs 0

(** val sarB1 : bits -> bits **)

let sarB1 bs =
  droplsb (joinmsb bs (msb bs))

(** val sarB : int -> bits -> bits **)

let sarB n bs =
  iter n sarB1 bs

(** val sarBB : bits -> bits -> bits **)

let sarBB bs ns =
  let szbs = size bs in
  let szns = size ns in
  let log2szbs = Nat.log2_up szbs in
  let msb_bs = msb bs in
  if leq szbs (Stdlib.succ 0)
  then if eq_op bitseq_eqType (Obj.magic ns) (Obj.magic zeros szns)
       then bs
       else nseq szbs msb_bs
  else if leq szns log2szbs
       then sarB (to_nat ns) bs
       else let zero_hi = zeros (subn szns log2szbs) in
            let ns_hi = high (subn szns log2szbs) ns in
            if eq_op bitseq_eqType (Obj.magic ns_hi) (Obj.magic zero_hi)
            then let ns_lo = low log2szbs ns in sarB (to_nat ns_lo) bs
            else nseq szbs msb_bs

(** val shlB1 : bits -> bits **)

let shlB1 bs =
  dropmsb (joinlsb false bs)

(** val shlB : int -> bits -> bits **)

let shlB n bs =
  iter n shlB1 bs

(** val shlBB : bits -> bits -> bits **)

let shlBB bs ns =
  let szbs = size bs in
  let szns = size ns in
  let log2szbs = Nat.log2_up szbs in
  if leq szbs (Stdlib.succ 0)
  then if eq_op bitseq_eqType (Obj.magic ns) (Obj.magic zeros szns)
       then bs
       else zeros szbs
  else if leq szns log2szbs
       then shlB (to_nat ns) bs
       else let zero_hi = zeros (subn szns log2szbs) in
            let ns_hi = high (subn szns log2szbs) ns in
            if eq_op bitseq_eqType (Obj.magic ns_hi) (Obj.magic zero_hi)
            then let ns_lo = low log2szbs ns in shlB (to_nat ns_lo) bs
            else from_nat szbs 0

(** val udivB_rec : bits -> bits -> bits -> bits -> bits * bits **)

let rec udivB_rec n m q r =
  match n with
  | [] -> (q, r)
  | nhd :: ntl ->
    let di = dropmsb (joinlsb nhd r) in
    let bi = leB m di in
    let ri = if bi then subB di m else di in
    let qi = dropmsb (joinlsb bi q) in udivB_rec ntl m qi ri

(** val udivB : bits -> bits -> bits * bits **)

let udivB n' m =
  let n = rev n' in
  if eq_op bitseq_eqType (Obj.magic from_Zpos (size n) (to_Zpos m))
       (Obj.magic zeros (size n))
  then ((ones (size n)), n')
  else udivB_rec n (from_Zpos (size n) (to_Zpos m)) (zeros (size n))
         (zeros (size n))

(** val udivB' : bits -> bits -> bits **)

let udivB' n m =
  fst (udivB n m)

(** val uremB : bits -> bits -> bits **)

let uremB bs1 bs2 =
  snd (udivB bs1 bs2)

(** val absB : bits -> bits **)

let absB bs =
  if msb bs then negB bs else bs

(** val sdivB : bits -> bits -> bits **)

let sdivB bs1' bs2' =
  let bs1 = absB bs1' in
  let bs2 = absB bs2' in
  if eq_op bool_eqType (Obj.magic msb bs1') (Obj.magic msb bs2')
  then fst (udivB bs1 bs2)
  else negB (fst (udivB bs1 bs2))

(** val sremB : bits -> bits -> bits **)

let sremB bs1' bs2' =
  let bs1 = absB bs1' in
  let bs2 = absB bs2' in
  if msb bs1' then negB (snd (udivB bs1 bs2)) else snd (udivB bs1 bs2)

(** val smodB : bits -> bits -> bits **)

let smodB bs1 bs2 =
  let r_sdiv = sremB bs1 bs2 in
  if (||) (eq_op bool_eqType (Obj.magic msb bs1) (Obj.magic msb bs2))
       (eq_op bitseq_eqType (Obj.magic r_sdiv)
         (Obj.magic zeros (size r_sdiv)))
  then r_sdiv
  else addB r_sdiv bs2
