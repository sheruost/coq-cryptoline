open Bool
open Datatypes
open Eqtype
open Ssrbool
open Ssrbool0
open Ssreflect
open Ssrnat

let __ = let rec f _ = Obj.repr f in Obj.repr f

(** val size : 'a1 list -> int **)

let rec size = function
| [] -> 0
| _ :: s' -> Stdlib.succ (size s')

(** val head : 'a1 -> 'a1 list -> 'a1 **)

let head x0 = function
| [] -> x0
| x :: _ -> x

(** val behead : 'a1 list -> 'a1 list **)

let behead = function
| [] -> []
| _ :: s' -> s'

(** val ncons : int -> 'a1 -> 'a1 list -> 'a1 list **)

let ncons n x =
  iter n (fun x0 -> x :: x0)

(** val nseq : int -> 'a1 -> 'a1 list **)

let nseq n x =
  ncons n x []

(** val cat : 'a1 list -> 'a1 list -> 'a1 list **)

let rec cat s1 s2 =
  match s1 with
  | [] -> s2
  | x :: s1' -> x :: (cat s1' s2)

(** val rcons : 'a1 list -> 'a1 -> 'a1 list **)

let rec rcons s z =
  match s with
  | [] -> z :: []
  | x :: s' -> x :: (rcons s' z)

(** val last : 'a1 -> 'a1 list -> 'a1 **)

let rec last x = function
| [] -> x
| x' :: s' -> last x' s'

(** val belast : 'a1 -> 'a1 list -> 'a1 list **)

let rec belast x = function
| [] -> []
| x' :: s' -> x :: (belast x' s')

(** val filter : 'a1 pred -> 'a1 list -> 'a1 list **)

let rec filter a = function
| [] -> []
| x :: s' -> if a x then x :: (filter a s') else filter a s'

(** val has : 'a1 pred -> 'a1 list -> bool **)

let rec has a = function
| [] -> false
| x :: s' -> (||) (a x) (has a s')

(** val all : 'a1 pred -> 'a1 list -> bool **)

let rec all a = function
| [] -> true
| x :: s' -> (&&) (a x) (all a s')

(** val drop : int -> 'a1 list -> 'a1 list **)

let rec drop n s = match s with
| [] -> s
| _ :: s' ->
  ((fun fO fS n -> if n=0 then fO () else fS (n-1))
     (fun _ -> s)
     (fun n' -> drop n' s')
     n)

(** val take : int -> 'a1 list -> 'a1 list **)

let rec take n = function
| [] -> []
| x :: s' ->
  ((fun fO fS n -> if n=0 then fO () else fS (n-1))
     (fun _ -> [])
     (fun n' -> x :: (take n' s'))
     n)

(** val catrev : 'a1 list -> 'a1 list -> 'a1 list **)

let rec catrev s1 s2 =
  match s1 with
  | [] -> s2
  | x :: s1' -> catrev s1' (x :: s2)

(** val rev : 'a1 list -> 'a1 list **)

let rev s =
  catrev s []

(** val eqseq :
    Equality.coq_type -> Equality.sort list -> Equality.sort list -> bool **)

let rec eqseq t s1 s2 =
  match s1 with
  | [] -> (match s2 with
           | [] -> true
           | _ :: _ -> false)
  | x1 :: s1' ->
    (match s2 with
     | [] -> false
     | x2 :: s2' -> (&&) (eq_op t x1 x2) (eqseq t s1' s2'))

(** val eqseqP : Equality.coq_type -> Equality.sort list Equality.axiom **)

let eqseqP t _top_assumption_ =
  let _evar_0_ = fun __top_assumption_ ->
    let _evar_0_ = ReflectT in
    let _evar_0_0 = fun _ _ -> ReflectF in
    (match __top_assumption_ with
     | [] -> _evar_0_
     | a :: l -> _evar_0_0 a l)
  in
  let _evar_0_0 = fun x1 s1 iHs __top_assumption_ ->
    let _evar_0_0 = ReflectF in
    let _evar_0_1 = fun x2 s2 ->
      ssr_have (eqP t x1 x2) (fun __top_assumption_0 ->
        let _evar_0_1 = fun _ -> iffP (eqseq t s1 s2) (iHs s2) in
        let _evar_0_2 = fun _ -> ReflectF in
        (match __top_assumption_0 with
         | ReflectT -> _evar_0_1 __
         | ReflectF -> _evar_0_2 __))
    in
    (match __top_assumption_ with
     | [] -> _evar_0_0
     | a :: l -> _evar_0_1 a l)
  in
  let rec f = function
  | [] -> _evar_0_
  | y :: l0 -> _evar_0_0 y l0 (f l0)
  in f _top_assumption_

(** val seq_eqMixin :
    Equality.coq_type -> Equality.sort list Equality.mixin_of **)

let seq_eqMixin t =
  { Equality.op = (eqseq t); Equality.mixin_of__1 = (eqseqP t) }

(** val seq_eqType : Equality.coq_type -> Equality.coq_type **)

let seq_eqType t =
  Obj.magic seq_eqMixin t

(** val mem_seq :
    Equality.coq_type -> Equality.sort list -> Equality.sort -> bool **)

let rec mem_seq t = function
| [] -> (fun _ -> false)
| y :: s' -> let p = mem_seq t s' in (fun x -> (||) (eq_op t x y) (p x))

type seq_eqclass = Equality.sort list

(** val pred_of_seq :
    Equality.coq_type -> seq_eqclass -> Equality.sort pred_sort **)

let pred_of_seq t s =
  Obj.magic mem_seq t s

(** val seq_predType : Equality.coq_type -> Equality.sort predType **)

let seq_predType t =
  coq_PredType (Obj.magic pred_of_seq t)

type bitseq = bool list

(** val bitseq_eqType : Equality.coq_type **)

let bitseq_eqType =
  Obj.magic seq_eqMixin bool_eqType

(** val map : ('a1 -> 'a2) -> 'a1 list -> 'a2 list **)

let rec map f = function
| [] -> []
| x :: s' -> (f x) :: (map f s')

(** val foldr : ('a1 -> 'a2 -> 'a2) -> 'a2 -> 'a1 list -> 'a2 **)

let rec foldr f z0 = function
| [] -> z0
| x :: s' -> f x (foldr f z0 s')

(** val foldl : ('a2 -> 'a1 -> 'a2) -> 'a2 -> 'a1 list -> 'a2 **)

let rec foldl f z = function
| [] -> z
| x :: s' -> foldl f (f z x) s'

(** val zip : 'a1 list -> 'a2 list -> ('a1 * 'a2) list **)

let rec zip s t =
  match s with
  | [] -> []
  | x :: s' -> (match t with
                | [] -> []
                | y :: t' -> (x, y) :: (zip s' t'))

(** val unzip1 : ('a1 * 'a2) list -> 'a1 list **)

let unzip1 s =
  map fst s

(** val unzip2 : ('a1 * 'a2) list -> 'a2 list **)

let unzip2 s =
  map snd s
