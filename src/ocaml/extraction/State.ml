open Bool
open Datatypes
open EqFMaps
open EqVar
open Int0
open List0
open NBitsDef
open Nat0
open OrdersTac
open Typ
open Eqtype

type __ = Obj.t
let __ = let rec f _ = Obj.repr f in Obj.repr f

module BitsValueType =
 struct
  type t = bits

  (** val default : t **)

  let default =
    []
 end

module MakeBitsStore =
 functor (V:EqOrder.EqOrder) ->
 functor (TE:TypEnv.TypEnv with module SE = V) ->
 struct
  module M =
   struct
    module M =
     struct
      module SE =
       struct
        (** val coq_T : Equality.coq_type **)

        let coq_T =
          V.coq_T

        type t = Equality.sort

        (** val ltn : t -> t -> bool **)

        let ltn =
          V.ltn

        (** val compare : t -> t -> t OrderedType.coq_Compare **)

        let compare =
          V.compare

        (** val eq_dec : t -> t -> bool **)

        let eq_dec =
          V.eq_dec
       end

      module E =
       struct
        type t = Equality.sort

        (** val compare :
            Equality.sort -> Equality.sort -> Equality.sort
            OrderedType.coq_Compare **)

        let compare =
          V.compare

        (** val eq_dec : Equality.sort -> Equality.sort -> bool **)

        let eq_dec =
          V.eq_dec
       end

      module Raw =
       struct
        type key = Equality.sort

        type 'elt tree =
        | Leaf
        | Node of 'elt tree * key * 'elt * 'elt tree * Z_as_Int.t

        (** val tree_rect :
            'a2 -> ('a1 tree -> 'a2 -> key -> 'a1 -> 'a1 tree -> 'a2 ->
            Z_as_Int.t -> 'a2) -> 'a1 tree -> 'a2 **)

        let rec tree_rect f f0 = function
        | Leaf -> f
        | Node (t1, k, y, t2, t3) ->
          f0 t1 (tree_rect f f0 t1) k y t2 (tree_rect f f0 t2) t3

        (** val tree_rec :
            'a2 -> ('a1 tree -> 'a2 -> key -> 'a1 -> 'a1 tree -> 'a2 ->
            Z_as_Int.t -> 'a2) -> 'a1 tree -> 'a2 **)

        let rec tree_rec f f0 = function
        | Leaf -> f
        | Node (t1, k, y, t2, t3) ->
          f0 t1 (tree_rec f f0 t1) k y t2 (tree_rec f f0 t2) t3

        (** val height : 'a1 tree -> Z_as_Int.t **)

        let height = function
        | Leaf -> Z_as_Int._0
        | Node (_, _, _, _, h) -> h

        (** val cardinal : 'a1 tree -> int **)

        let rec cardinal = function
        | Leaf -> 0
        | Node (l, _, _, r, _) ->
          Stdlib.succ (add (cardinal l) (cardinal r))

        (** val empty : 'a1 tree **)

        let empty =
          Leaf

        (** val is_empty : 'a1 tree -> bool **)

        let is_empty = function
        | Leaf -> true
        | Node (_, _, _, _, _) -> false

        (** val mem : Equality.sort -> 'a1 tree -> bool **)

        let rec mem x = function
        | Leaf -> false
        | Node (l, y, _, r, _) ->
          (match V.compare x y with
           | OrderedType.LT -> mem x l
           | OrderedType.EQ -> true
           | OrderedType.GT -> mem x r)

        (** val find : Equality.sort -> 'a1 tree -> 'a1 option **)

        let rec find x = function
        | Leaf -> None
        | Node (l, y, d, r, _) ->
          (match V.compare x y with
           | OrderedType.LT -> find x l
           | OrderedType.EQ -> Some d
           | OrderedType.GT -> find x r)

        (** val create : 'a1 tree -> key -> 'a1 -> 'a1 tree -> 'a1 tree **)

        let create l x e r =
          Node (l, x, e, r,
            (Z_as_Int.add (Z_as_Int.max (height l) (height r)) Z_as_Int._1))

        (** val assert_false :
            'a1 tree -> key -> 'a1 -> 'a1 tree -> 'a1 tree **)

        let assert_false =
          create

        (** val bal : 'a1 tree -> key -> 'a1 -> 'a1 tree -> 'a1 tree **)

        let bal l x d r =
          let hl = height l in
          let hr = height r in
          if Z_as_Int.gt_le_dec hl (Z_as_Int.add hr Z_as_Int._2)
          then (match l with
                | Leaf -> assert_false l x d r
                | Node (ll, lx, ld, lr, _) ->
                  if Z_as_Int.ge_lt_dec (height ll) (height lr)
                  then create ll lx ld (create lr x d r)
                  else (match lr with
                        | Leaf -> assert_false l x d r
                        | Node (lrl, lrx, lrd, lrr, _) ->
                          create (create ll lx ld lrl) lrx lrd
                            (create lrr x d r)))
          else if Z_as_Int.gt_le_dec hr (Z_as_Int.add hl Z_as_Int._2)
               then (match r with
                     | Leaf -> assert_false l x d r
                     | Node (rl, rx, rd, rr, _) ->
                       if Z_as_Int.ge_lt_dec (height rr) (height rl)
                       then create (create l x d rl) rx rd rr
                       else (match rl with
                             | Leaf -> assert_false l x d r
                             | Node (rll, rlx, rld, rlr, _) ->
                               create (create l x d rll) rlx rld
                                 (create rlr rx rd rr)))
               else create l x d r

        (** val add : key -> 'a1 -> 'a1 tree -> 'a1 tree **)

        let rec add x d = function
        | Leaf -> Node (Leaf, x, d, Leaf, Z_as_Int._1)
        | Node (l, y, d', r, h) ->
          (match V.compare x y with
           | OrderedType.LT -> bal (add x d l) y d' r
           | OrderedType.EQ -> Node (l, y, d, r, h)
           | OrderedType.GT -> bal l y d' (add x d r))

        (** val remove_min :
            'a1 tree -> key -> 'a1 -> 'a1 tree -> 'a1 tree * (key * 'a1) **)

        let rec remove_min l x d r =
          match l with
          | Leaf -> (r, (x, d))
          | Node (ll, lx, ld, lr, _) ->
            let (l', m) = remove_min ll lx ld lr in ((bal l' x d r), m)

        (** val merge : 'a1 tree -> 'a1 tree -> 'a1 tree **)

        let merge s1 s2 =
          match s1 with
          | Leaf -> s2
          | Node (_, _, _, _, _) ->
            (match s2 with
             | Leaf -> s1
             | Node (l2, x2, d2, r2, _) ->
               let (s2', p) = remove_min l2 x2 d2 r2 in
               let (x, d) = p in bal s1 x d s2')

        (** val remove : Equality.sort -> 'a1 tree -> 'a1 tree **)

        let rec remove x = function
        | Leaf -> Leaf
        | Node (l, y, d, r, _) ->
          (match V.compare x y with
           | OrderedType.LT -> bal (remove x l) y d r
           | OrderedType.EQ -> merge l r
           | OrderedType.GT -> bal l y d (remove x r))

        (** val join : 'a1 tree -> key -> 'a1 -> 'a1 tree -> 'a1 tree **)

        let rec join l = match l with
        | Leaf -> add
        | Node (ll, lx, ld, lr, lh) ->
          (fun x d ->
            let rec join_aux r = match r with
            | Leaf -> add x d l
            | Node (rl, rx, rd, rr, rh) ->
              if Z_as_Int.gt_le_dec lh (Z_as_Int.add rh Z_as_Int._2)
              then bal ll lx ld (join lr x d r)
              else if Z_as_Int.gt_le_dec rh (Z_as_Int.add lh Z_as_Int._2)
                   then bal (join_aux rl) rx rd rr
                   else create l x d r
            in join_aux)

        type 'elt triple = { t_left : 'elt tree; t_opt : 'elt option;
                             t_right : 'elt tree }

        (** val t_left : 'a1 triple -> 'a1 tree **)

        let t_left t0 =
          t0.t_left

        (** val t_opt : 'a1 triple -> 'a1 option **)

        let t_opt t0 =
          t0.t_opt

        (** val t_right : 'a1 triple -> 'a1 tree **)

        let t_right t0 =
          t0.t_right

        (** val split : Equality.sort -> 'a1 tree -> 'a1 triple **)

        let rec split x = function
        | Leaf -> { t_left = Leaf; t_opt = None; t_right = Leaf }
        | Node (l, y, d, r, _) ->
          (match V.compare x y with
           | OrderedType.LT ->
             let { t_left = ll; t_opt = o; t_right = rl } = split x l in
             { t_left = ll; t_opt = o; t_right = (join rl y d r) }
           | OrderedType.EQ -> { t_left = l; t_opt = (Some d); t_right = r }
           | OrderedType.GT ->
             let { t_left = rl; t_opt = o; t_right = rr } = split x r in
             { t_left = (join l y d rl); t_opt = o; t_right = rr })

        (** val concat : 'a1 tree -> 'a1 tree -> 'a1 tree **)

        let concat m1 m2 =
          match m1 with
          | Leaf -> m2
          | Node (_, _, _, _, _) ->
            (match m2 with
             | Leaf -> m1
             | Node (l2, x2, d2, r2, _) ->
               let (m2', xd) = remove_min l2 x2 d2 r2 in
               join m1 (fst xd) (snd xd) m2')

        (** val elements_aux :
            (key * 'a1) list -> 'a1 tree -> (key * 'a1) list **)

        let rec elements_aux acc0 = function
        | Leaf -> acc0
        | Node (l, x, d, r, _) ->
          elements_aux ((x, d) :: (elements_aux acc0 r)) l

        (** val elements : 'a1 tree -> (key * 'a1) list **)

        let elements m =
          elements_aux [] m

        (** val fold :
            (key -> 'a1 -> 'a2 -> 'a2) -> 'a1 tree -> 'a2 -> 'a2 **)

        let rec fold f m a =
          match m with
          | Leaf -> a
          | Node (l, x, d, r, _) -> fold f r (f x d (fold f l a))

        type 'elt enumeration =
        | End
        | More of key * 'elt * 'elt tree * 'elt enumeration

        (** val enumeration_rect :
            'a2 -> (key -> 'a1 -> 'a1 tree -> 'a1 enumeration -> 'a2 -> 'a2)
            -> 'a1 enumeration -> 'a2 **)

        let rec enumeration_rect f f0 = function
        | End -> f
        | More (k, e0, t0, e1) -> f0 k e0 t0 e1 (enumeration_rect f f0 e1)

        (** val enumeration_rec :
            'a2 -> (key -> 'a1 -> 'a1 tree -> 'a1 enumeration -> 'a2 -> 'a2)
            -> 'a1 enumeration -> 'a2 **)

        let rec enumeration_rec f f0 = function
        | End -> f
        | More (k, e0, t0, e1) -> f0 k e0 t0 e1 (enumeration_rec f f0 e1)

        (** val cons : 'a1 tree -> 'a1 enumeration -> 'a1 enumeration **)

        let rec cons m e =
          match m with
          | Leaf -> e
          | Node (l, x, d, r, _) -> cons l (More (x, d, r, e))

        (** val equal_more :
            ('a1 -> 'a1 -> bool) -> Equality.sort -> 'a1 -> ('a1 enumeration
            -> bool) -> 'a1 enumeration -> bool **)

        let equal_more cmp x1 d1 cont = function
        | End -> false
        | More (x2, d2, r2, e3) ->
          (match V.compare x1 x2 with
           | OrderedType.EQ -> if cmp d1 d2 then cont (cons r2 e3) else false
           | _ -> false)

        (** val equal_cont :
            ('a1 -> 'a1 -> bool) -> 'a1 tree -> ('a1 enumeration -> bool) ->
            'a1 enumeration -> bool **)

        let rec equal_cont cmp m1 cont e2 =
          match m1 with
          | Leaf -> cont e2
          | Node (l1, x1, d1, r1, _) ->
            equal_cont cmp l1 (equal_more cmp x1 d1 (equal_cont cmp r1 cont))
              e2

        (** val equal_end : 'a1 enumeration -> bool **)

        let equal_end = function
        | End -> true
        | More (_, _, _, _) -> false

        (** val equal :
            ('a1 -> 'a1 -> bool) -> 'a1 tree -> 'a1 tree -> bool **)

        let equal cmp m1 m2 =
          equal_cont cmp m1 equal_end (cons m2 End)

        (** val map : ('a1 -> 'a2) -> 'a1 tree -> 'a2 tree **)

        let rec map f = function
        | Leaf -> Leaf
        | Node (l, x, d, r, h) -> Node ((map f l), x, (f d), (map f r), h)

        (** val mapi : (key -> 'a1 -> 'a2) -> 'a1 tree -> 'a2 tree **)

        let rec mapi f = function
        | Leaf -> Leaf
        | Node (l, x, d, r, h) -> Node ((mapi f l), x, (f x d), (mapi f r), h)

        (** val map_option :
            (key -> 'a1 -> 'a2 option) -> 'a1 tree -> 'a2 tree **)

        let rec map_option f = function
        | Leaf -> Leaf
        | Node (l, x, d, r, _) ->
          (match f x d with
           | Some d' -> join (map_option f l) x d' (map_option f r)
           | None -> concat (map_option f l) (map_option f r))

        (** val map2_opt :
            (key -> 'a1 -> 'a2 option -> 'a3 option) -> ('a1 tree -> 'a3
            tree) -> ('a2 tree -> 'a3 tree) -> 'a1 tree -> 'a2 tree -> 'a3
            tree **)

        let rec map2_opt f mapl mapr m1 m2 =
          match m1 with
          | Leaf -> mapr m2
          | Node (l1, x1, d1, r1, _) ->
            (match m2 with
             | Leaf -> mapl m1
             | Node (_, _, _, _, _) ->
               let { t_left = l2'; t_opt = o2; t_right = r2' } = split x1 m2
               in
               (match f x1 d1 o2 with
                | Some e ->
                  join (map2_opt f mapl mapr l1 l2') x1 e
                    (map2_opt f mapl mapr r1 r2')
                | None ->
                  concat (map2_opt f mapl mapr l1 l2')
                    (map2_opt f mapl mapr r1 r2')))

        (** val map2 :
            ('a1 option -> 'a2 option -> 'a3 option) -> 'a1 tree -> 'a2 tree
            -> 'a3 tree **)

        let map2 f =
          map2_opt (fun _ d o -> f (Some d) o)
            (map_option (fun _ d -> f (Some d) None))
            (map_option (fun _ d' -> f None (Some d')))

        module Proofs =
         struct
          module MX =
           struct
            module TO =
             struct
              type t = Equality.sort
             end

            module IsTO =
             struct
             end

            module OrderTac = MakeOrderTac(TO)(IsTO)

            (** val eq_dec : Equality.sort -> Equality.sort -> bool **)

            let eq_dec =
              V.eq_dec

            (** val lt_dec : Equality.sort -> Equality.sort -> bool **)

            let lt_dec x y =
              match V.compare x y with
              | OrderedType.LT -> true
              | _ -> false

            (** val eqb : Equality.sort -> Equality.sort -> bool **)

            let eqb x y =
              if eq_dec x y then true else false
           end

          module PX =
           struct
            module MO =
             struct
              module TO =
               struct
                type t = Equality.sort
               end

              module IsTO =
               struct
               end

              module OrderTac = MakeOrderTac(TO)(IsTO)

              (** val eq_dec : Equality.sort -> Equality.sort -> bool **)

              let eq_dec =
                V.eq_dec

              (** val lt_dec : Equality.sort -> Equality.sort -> bool **)

              let lt_dec x y =
                match V.compare x y with
                | OrderedType.LT -> true
                | _ -> false

              (** val eqb : Equality.sort -> Equality.sort -> bool **)

              let eqb x y =
                if eq_dec x y then true else false
             end
           end

          module L =
           struct
            module MX =
             struct
              module TO =
               struct
                type t = Equality.sort
               end

              module IsTO =
               struct
               end

              module OrderTac = MakeOrderTac(TO)(IsTO)

              (** val eq_dec : Equality.sort -> Equality.sort -> bool **)

              let eq_dec =
                V.eq_dec

              (** val lt_dec : Equality.sort -> Equality.sort -> bool **)

              let lt_dec x y =
                match V.compare x y with
                | OrderedType.LT -> true
                | _ -> false

              (** val eqb : Equality.sort -> Equality.sort -> bool **)

              let eqb x y =
                if eq_dec x y then true else false
             end

            module PX =
             struct
              module MO =
               struct
                module TO =
                 struct
                  type t = Equality.sort
                 end

                module IsTO =
                 struct
                 end

                module OrderTac = MakeOrderTac(TO)(IsTO)

                (** val eq_dec : Equality.sort -> Equality.sort -> bool **)

                let eq_dec =
                  V.eq_dec

                (** val lt_dec : Equality.sort -> Equality.sort -> bool **)

                let lt_dec x y =
                  match V.compare x y with
                  | OrderedType.LT -> true
                  | _ -> false

                (** val eqb : Equality.sort -> Equality.sort -> bool **)

                let eqb x y =
                  if eq_dec x y then true else false
               end
             end

            type key = Equality.sort

            type 'elt t = (Equality.sort * 'elt) list

            (** val empty : 'a1 t **)

            let empty =
              []

            (** val is_empty : 'a1 t -> bool **)

            let is_empty = function
            | [] -> true
            | _ :: _ -> false

            (** val mem : key -> 'a1 t -> bool **)

            let rec mem k = function
            | [] -> false
            | p :: l ->
              let (k', _) = p in
              (match V.compare k k' with
               | OrderedType.LT -> false
               | OrderedType.EQ -> true
               | OrderedType.GT -> mem k l)

            type 'elt coq_R_mem =
            | R_mem_0 of 'elt t
            | R_mem_1 of 'elt t * Equality.sort * 'elt
               * (Equality.sort * 'elt) list
            | R_mem_2 of 'elt t * Equality.sort * 'elt
               * (Equality.sort * 'elt) list
            | R_mem_3 of 'elt t * Equality.sort * 'elt
               * (Equality.sort * 'elt) list * bool * 'elt coq_R_mem

            (** val coq_R_mem_rect :
                key -> ('a1 t -> __ -> 'a2) -> ('a1 t -> Equality.sort -> 'a1
                -> (Equality.sort * 'a1) list -> __ -> __ -> __ -> 'a2) ->
                ('a1 t -> Equality.sort -> 'a1 -> (Equality.sort * 'a1) list
                -> __ -> __ -> __ -> 'a2) -> ('a1 t -> Equality.sort -> 'a1
                -> (Equality.sort * 'a1) list -> __ -> __ -> __ -> bool ->
                'a1 coq_R_mem -> 'a2 -> 'a2) -> 'a1 t -> bool -> 'a1
                coq_R_mem -> 'a2 **)

            let rec coq_R_mem_rect k f f0 f1 f2 _ _ = function
            | R_mem_0 s -> f s __
            | R_mem_1 (s, k', _x, l) -> f0 s k' _x l __ __ __
            | R_mem_2 (s, k', _x, l) -> f1 s k' _x l __ __ __
            | R_mem_3 (s, k', _x, l, _res, r0) ->
              f2 s k' _x l __ __ __ _res r0
                (coq_R_mem_rect k f f0 f1 f2 l _res r0)

            (** val coq_R_mem_rec :
                key -> ('a1 t -> __ -> 'a2) -> ('a1 t -> Equality.sort -> 'a1
                -> (Equality.sort * 'a1) list -> __ -> __ -> __ -> 'a2) ->
                ('a1 t -> Equality.sort -> 'a1 -> (Equality.sort * 'a1) list
                -> __ -> __ -> __ -> 'a2) -> ('a1 t -> Equality.sort -> 'a1
                -> (Equality.sort * 'a1) list -> __ -> __ -> __ -> bool ->
                'a1 coq_R_mem -> 'a2 -> 'a2) -> 'a1 t -> bool -> 'a1
                coq_R_mem -> 'a2 **)

            let rec coq_R_mem_rec k f f0 f1 f2 _ _ = function
            | R_mem_0 s -> f s __
            | R_mem_1 (s, k', _x, l) -> f0 s k' _x l __ __ __
            | R_mem_2 (s, k', _x, l) -> f1 s k' _x l __ __ __
            | R_mem_3 (s, k', _x, l, _res, r0) ->
              f2 s k' _x l __ __ __ _res r0
                (coq_R_mem_rec k f f0 f1 f2 l _res r0)

            (** val mem_rect :
                key -> ('a1 t -> __ -> 'a2) -> ('a1 t -> Equality.sort -> 'a1
                -> (Equality.sort * 'a1) list -> __ -> __ -> __ -> 'a2) ->
                ('a1 t -> Equality.sort -> 'a1 -> (Equality.sort * 'a1) list
                -> __ -> __ -> __ -> 'a2) -> ('a1 t -> Equality.sort -> 'a1
                -> (Equality.sort * 'a1) list -> __ -> __ -> __ -> 'a2 ->
                'a2) -> 'a1 t -> 'a2 **)

            let rec mem_rect k f f0 f1 f2 s =
              let f3 = f s in
              let f4 = f0 s in
              let f5 = f1 s in
              let f6 = f2 s in
              (match s with
               | [] -> f3 __
               | a :: l ->
                 let (a0, b) = a in
                 let f7 = f6 a0 b l __ in
                 let f8 = fun _ _ ->
                   let hrec = mem_rect k f f0 f1 f2 l in f7 __ __ hrec
                 in
                 let f9 = f5 a0 b l __ in
                 let f10 = f4 a0 b l __ in
                 (match V.compare k a0 with
                  | OrderedType.LT -> f10 __ __
                  | OrderedType.EQ -> f9 __ __
                  | OrderedType.GT -> f8 __ __))

            (** val mem_rec :
                key -> ('a1 t -> __ -> 'a2) -> ('a1 t -> Equality.sort -> 'a1
                -> (Equality.sort * 'a1) list -> __ -> __ -> __ -> 'a2) ->
                ('a1 t -> Equality.sort -> 'a1 -> (Equality.sort * 'a1) list
                -> __ -> __ -> __ -> 'a2) -> ('a1 t -> Equality.sort -> 'a1
                -> (Equality.sort * 'a1) list -> __ -> __ -> __ -> 'a2 ->
                'a2) -> 'a1 t -> 'a2 **)

            let mem_rec =
              mem_rect

            (** val coq_R_mem_correct :
                key -> 'a1 t -> bool -> 'a1 coq_R_mem **)

            let coq_R_mem_correct k s _res =
              Obj.magic mem_rect k (fun y _ _ _ -> R_mem_0 y)
                (fun y y0 y1 y2 _ _ _ _ _ -> R_mem_1 (y, y0, y1, y2))
                (fun y y0 y1 y2 _ _ _ _ _ -> R_mem_2 (y, y0, y1, y2))
                (fun y y0 y1 y2 _ _ _ y6 _ _ -> R_mem_3 (y, y0, y1, y2,
                (mem k y2), (y6 (mem k y2) __))) s _res __

            (** val find : key -> 'a1 t -> 'a1 option **)

            let rec find k = function
            | [] -> None
            | p :: s' ->
              let (k', x) = p in
              (match V.compare k k' with
               | OrderedType.LT -> None
               | OrderedType.EQ -> Some x
               | OrderedType.GT -> find k s')

            type 'elt coq_R_find =
            | R_find_0 of 'elt t
            | R_find_1 of 'elt t * Equality.sort * 'elt
               * (Equality.sort * 'elt) list
            | R_find_2 of 'elt t * Equality.sort * 'elt
               * (Equality.sort * 'elt) list
            | R_find_3 of 'elt t * Equality.sort * 'elt
               * (Equality.sort * 'elt) list * 'elt option * 'elt coq_R_find

            (** val coq_R_find_rect :
                key -> ('a1 t -> __ -> 'a2) -> ('a1 t -> Equality.sort -> 'a1
                -> (Equality.sort * 'a1) list -> __ -> __ -> __ -> 'a2) ->
                ('a1 t -> Equality.sort -> 'a1 -> (Equality.sort * 'a1) list
                -> __ -> __ -> __ -> 'a2) -> ('a1 t -> Equality.sort -> 'a1
                -> (Equality.sort * 'a1) list -> __ -> __ -> __ -> 'a1 option
                -> 'a1 coq_R_find -> 'a2 -> 'a2) -> 'a1 t -> 'a1 option ->
                'a1 coq_R_find -> 'a2 **)

            let rec coq_R_find_rect k f f0 f1 f2 _ _ = function
            | R_find_0 s -> f s __
            | R_find_1 (s, k', x, s') -> f0 s k' x s' __ __ __
            | R_find_2 (s, k', x, s') -> f1 s k' x s' __ __ __
            | R_find_3 (s, k', x, s', _res, r0) ->
              f2 s k' x s' __ __ __ _res r0
                (coq_R_find_rect k f f0 f1 f2 s' _res r0)

            (** val coq_R_find_rec :
                key -> ('a1 t -> __ -> 'a2) -> ('a1 t -> Equality.sort -> 'a1
                -> (Equality.sort * 'a1) list -> __ -> __ -> __ -> 'a2) ->
                ('a1 t -> Equality.sort -> 'a1 -> (Equality.sort * 'a1) list
                -> __ -> __ -> __ -> 'a2) -> ('a1 t -> Equality.sort -> 'a1
                -> (Equality.sort * 'a1) list -> __ -> __ -> __ -> 'a1 option
                -> 'a1 coq_R_find -> 'a2 -> 'a2) -> 'a1 t -> 'a1 option ->
                'a1 coq_R_find -> 'a2 **)

            let rec coq_R_find_rec k f f0 f1 f2 _ _ = function
            | R_find_0 s -> f s __
            | R_find_1 (s, k', x, s') -> f0 s k' x s' __ __ __
            | R_find_2 (s, k', x, s') -> f1 s k' x s' __ __ __
            | R_find_3 (s, k', x, s', _res, r0) ->
              f2 s k' x s' __ __ __ _res r0
                (coq_R_find_rec k f f0 f1 f2 s' _res r0)

            (** val find_rect :
                key -> ('a1 t -> __ -> 'a2) -> ('a1 t -> Equality.sort -> 'a1
                -> (Equality.sort * 'a1) list -> __ -> __ -> __ -> 'a2) ->
                ('a1 t -> Equality.sort -> 'a1 -> (Equality.sort * 'a1) list
                -> __ -> __ -> __ -> 'a2) -> ('a1 t -> Equality.sort -> 'a1
                -> (Equality.sort * 'a1) list -> __ -> __ -> __ -> 'a2 ->
                'a2) -> 'a1 t -> 'a2 **)

            let rec find_rect k f f0 f1 f2 s =
              let f3 = f s in
              let f4 = f0 s in
              let f5 = f1 s in
              let f6 = f2 s in
              (match s with
               | [] -> f3 __
               | a :: l ->
                 let (a0, b) = a in
                 let f7 = f6 a0 b l __ in
                 let f8 = fun _ _ ->
                   let hrec = find_rect k f f0 f1 f2 l in f7 __ __ hrec
                 in
                 let f9 = f5 a0 b l __ in
                 let f10 = f4 a0 b l __ in
                 (match V.compare k a0 with
                  | OrderedType.LT -> f10 __ __
                  | OrderedType.EQ -> f9 __ __
                  | OrderedType.GT -> f8 __ __))

            (** val find_rec :
                key -> ('a1 t -> __ -> 'a2) -> ('a1 t -> Equality.sort -> 'a1
                -> (Equality.sort * 'a1) list -> __ -> __ -> __ -> 'a2) ->
                ('a1 t -> Equality.sort -> 'a1 -> (Equality.sort * 'a1) list
                -> __ -> __ -> __ -> 'a2) -> ('a1 t -> Equality.sort -> 'a1
                -> (Equality.sort * 'a1) list -> __ -> __ -> __ -> 'a2 ->
                'a2) -> 'a1 t -> 'a2 **)

            let find_rec =
              find_rect

            (** val coq_R_find_correct :
                key -> 'a1 t -> 'a1 option -> 'a1 coq_R_find **)

            let coq_R_find_correct k s _res =
              Obj.magic find_rect k (fun y _ _ _ -> R_find_0 y)
                (fun y y0 y1 y2 _ _ _ _ _ -> R_find_1 (y, y0, y1, y2))
                (fun y y0 y1 y2 _ _ _ _ _ -> R_find_2 (y, y0, y1, y2))
                (fun y y0 y1 y2 _ _ _ y6 _ _ -> R_find_3 (y, y0, y1, y2,
                (find k y2), (y6 (find k y2) __))) s _res __

            (** val add : key -> 'a1 -> 'a1 t -> 'a1 t **)

            let rec add k x s = match s with
            | [] -> (k, x) :: []
            | p :: l ->
              let (k', y) = p in
              (match V.compare k k' with
               | OrderedType.LT -> (k, x) :: s
               | OrderedType.EQ -> (k, x) :: l
               | OrderedType.GT -> (k', y) :: (add k x l))

            type 'elt coq_R_add =
            | R_add_0 of 'elt t
            | R_add_1 of 'elt t * Equality.sort * 'elt
               * (Equality.sort * 'elt) list
            | R_add_2 of 'elt t * Equality.sort * 'elt
               * (Equality.sort * 'elt) list
            | R_add_3 of 'elt t * Equality.sort * 'elt
               * (Equality.sort * 'elt) list * 'elt t * 'elt coq_R_add

            (** val coq_R_add_rect :
                key -> 'a1 -> ('a1 t -> __ -> 'a2) -> ('a1 t -> Equality.sort
                -> 'a1 -> (Equality.sort * 'a1) list -> __ -> __ -> __ ->
                'a2) -> ('a1 t -> Equality.sort -> 'a1 ->
                (Equality.sort * 'a1) list -> __ -> __ -> __ -> 'a2) -> ('a1
                t -> Equality.sort -> 'a1 -> (Equality.sort * 'a1) list -> __
                -> __ -> __ -> 'a1 t -> 'a1 coq_R_add -> 'a2 -> 'a2) -> 'a1 t
                -> 'a1 t -> 'a1 coq_R_add -> 'a2 **)

            let rec coq_R_add_rect k x f f0 f1 f2 _ _ = function
            | R_add_0 s -> f s __
            | R_add_1 (s, k', y, l) -> f0 s k' y l __ __ __
            | R_add_2 (s, k', y, l) -> f1 s k' y l __ __ __
            | R_add_3 (s, k', y, l, _res, r0) ->
              f2 s k' y l __ __ __ _res r0
                (coq_R_add_rect k x f f0 f1 f2 l _res r0)

            (** val coq_R_add_rec :
                key -> 'a1 -> ('a1 t -> __ -> 'a2) -> ('a1 t -> Equality.sort
                -> 'a1 -> (Equality.sort * 'a1) list -> __ -> __ -> __ ->
                'a2) -> ('a1 t -> Equality.sort -> 'a1 ->
                (Equality.sort * 'a1) list -> __ -> __ -> __ -> 'a2) -> ('a1
                t -> Equality.sort -> 'a1 -> (Equality.sort * 'a1) list -> __
                -> __ -> __ -> 'a1 t -> 'a1 coq_R_add -> 'a2 -> 'a2) -> 'a1 t
                -> 'a1 t -> 'a1 coq_R_add -> 'a2 **)

            let rec coq_R_add_rec k x f f0 f1 f2 _ _ = function
            | R_add_0 s -> f s __
            | R_add_1 (s, k', y, l) -> f0 s k' y l __ __ __
            | R_add_2 (s, k', y, l) -> f1 s k' y l __ __ __
            | R_add_3 (s, k', y, l, _res, r0) ->
              f2 s k' y l __ __ __ _res r0
                (coq_R_add_rec k x f f0 f1 f2 l _res r0)

            (** val add_rect :
                key -> 'a1 -> ('a1 t -> __ -> 'a2) -> ('a1 t -> Equality.sort
                -> 'a1 -> (Equality.sort * 'a1) list -> __ -> __ -> __ ->
                'a2) -> ('a1 t -> Equality.sort -> 'a1 ->
                (Equality.sort * 'a1) list -> __ -> __ -> __ -> 'a2) -> ('a1
                t -> Equality.sort -> 'a1 -> (Equality.sort * 'a1) list -> __
                -> __ -> __ -> 'a2 -> 'a2) -> 'a1 t -> 'a2 **)

            let rec add_rect k x f f0 f1 f2 s =
              let f3 = f s in
              let f4 = f0 s in
              let f5 = f1 s in
              let f6 = f2 s in
              (match s with
               | [] -> f3 __
               | a :: l ->
                 let (a0, b) = a in
                 let f7 = f6 a0 b l __ in
                 let f8 = fun _ _ ->
                   let hrec = add_rect k x f f0 f1 f2 l in f7 __ __ hrec
                 in
                 let f9 = f5 a0 b l __ in
                 let f10 = f4 a0 b l __ in
                 (match V.compare k a0 with
                  | OrderedType.LT -> f10 __ __
                  | OrderedType.EQ -> f9 __ __
                  | OrderedType.GT -> f8 __ __))

            (** val add_rec :
                key -> 'a1 -> ('a1 t -> __ -> 'a2) -> ('a1 t -> Equality.sort
                -> 'a1 -> (Equality.sort * 'a1) list -> __ -> __ -> __ ->
                'a2) -> ('a1 t -> Equality.sort -> 'a1 ->
                (Equality.sort * 'a1) list -> __ -> __ -> __ -> 'a2) -> ('a1
                t -> Equality.sort -> 'a1 -> (Equality.sort * 'a1) list -> __
                -> __ -> __ -> 'a2 -> 'a2) -> 'a1 t -> 'a2 **)

            let add_rec =
              add_rect

            (** val coq_R_add_correct :
                key -> 'a1 -> 'a1 t -> 'a1 t -> 'a1 coq_R_add **)

            let coq_R_add_correct k x s _res =
              add_rect k x (fun y _ _ _ -> R_add_0 y)
                (fun y y0 y1 y2 _ _ _ _ _ -> R_add_1 (y, y0, y1, y2))
                (fun y y0 y1 y2 _ _ _ _ _ -> R_add_2 (y, y0, y1, y2))
                (fun y y0 y1 y2 _ _ _ y6 _ _ -> R_add_3 (y, y0, y1, y2,
                (add k x y2), (y6 (add k x y2) __))) s _res __

            (** val remove : key -> 'a1 t -> 'a1 t **)

            let rec remove k s = match s with
            | [] -> []
            | p :: l ->
              let (k', x) = p in
              (match V.compare k k' with
               | OrderedType.LT -> s
               | OrderedType.EQ -> l
               | OrderedType.GT -> (k', x) :: (remove k l))

            type 'elt coq_R_remove =
            | R_remove_0 of 'elt t
            | R_remove_1 of 'elt t * Equality.sort * 'elt
               * (Equality.sort * 'elt) list
            | R_remove_2 of 'elt t * Equality.sort * 'elt
               * (Equality.sort * 'elt) list
            | R_remove_3 of 'elt t * Equality.sort * 'elt
               * (Equality.sort * 'elt) list * 'elt t * 'elt coq_R_remove

            (** val coq_R_remove_rect :
                key -> ('a1 t -> __ -> 'a2) -> ('a1 t -> Equality.sort -> 'a1
                -> (Equality.sort * 'a1) list -> __ -> __ -> __ -> 'a2) ->
                ('a1 t -> Equality.sort -> 'a1 -> (Equality.sort * 'a1) list
                -> __ -> __ -> __ -> 'a2) -> ('a1 t -> Equality.sort -> 'a1
                -> (Equality.sort * 'a1) list -> __ -> __ -> __ -> 'a1 t ->
                'a1 coq_R_remove -> 'a2 -> 'a2) -> 'a1 t -> 'a1 t -> 'a1
                coq_R_remove -> 'a2 **)

            let rec coq_R_remove_rect k f f0 f1 f2 _ _ = function
            | R_remove_0 s -> f s __
            | R_remove_1 (s, k', x, l) -> f0 s k' x l __ __ __
            | R_remove_2 (s, k', x, l) -> f1 s k' x l __ __ __
            | R_remove_3 (s, k', x, l, _res, r0) ->
              f2 s k' x l __ __ __ _res r0
                (coq_R_remove_rect k f f0 f1 f2 l _res r0)

            (** val coq_R_remove_rec :
                key -> ('a1 t -> __ -> 'a2) -> ('a1 t -> Equality.sort -> 'a1
                -> (Equality.sort * 'a1) list -> __ -> __ -> __ -> 'a2) ->
                ('a1 t -> Equality.sort -> 'a1 -> (Equality.sort * 'a1) list
                -> __ -> __ -> __ -> 'a2) -> ('a1 t -> Equality.sort -> 'a1
                -> (Equality.sort * 'a1) list -> __ -> __ -> __ -> 'a1 t ->
                'a1 coq_R_remove -> 'a2 -> 'a2) -> 'a1 t -> 'a1 t -> 'a1
                coq_R_remove -> 'a2 **)

            let rec coq_R_remove_rec k f f0 f1 f2 _ _ = function
            | R_remove_0 s -> f s __
            | R_remove_1 (s, k', x, l) -> f0 s k' x l __ __ __
            | R_remove_2 (s, k', x, l) -> f1 s k' x l __ __ __
            | R_remove_3 (s, k', x, l, _res, r0) ->
              f2 s k' x l __ __ __ _res r0
                (coq_R_remove_rec k f f0 f1 f2 l _res r0)

            (** val remove_rect :
                key -> ('a1 t -> __ -> 'a2) -> ('a1 t -> Equality.sort -> 'a1
                -> (Equality.sort * 'a1) list -> __ -> __ -> __ -> 'a2) ->
                ('a1 t -> Equality.sort -> 'a1 -> (Equality.sort * 'a1) list
                -> __ -> __ -> __ -> 'a2) -> ('a1 t -> Equality.sort -> 'a1
                -> (Equality.sort * 'a1) list -> __ -> __ -> __ -> 'a2 ->
                'a2) -> 'a1 t -> 'a2 **)

            let rec remove_rect k f f0 f1 f2 s =
              let f3 = f s in
              let f4 = f0 s in
              let f5 = f1 s in
              let f6 = f2 s in
              (match s with
               | [] -> f3 __
               | a :: l ->
                 let (a0, b) = a in
                 let f7 = f6 a0 b l __ in
                 let f8 = fun _ _ ->
                   let hrec = remove_rect k f f0 f1 f2 l in f7 __ __ hrec
                 in
                 let f9 = f5 a0 b l __ in
                 let f10 = f4 a0 b l __ in
                 (match V.compare k a0 with
                  | OrderedType.LT -> f10 __ __
                  | OrderedType.EQ -> f9 __ __
                  | OrderedType.GT -> f8 __ __))

            (** val remove_rec :
                key -> ('a1 t -> __ -> 'a2) -> ('a1 t -> Equality.sort -> 'a1
                -> (Equality.sort * 'a1) list -> __ -> __ -> __ -> 'a2) ->
                ('a1 t -> Equality.sort -> 'a1 -> (Equality.sort * 'a1) list
                -> __ -> __ -> __ -> 'a2) -> ('a1 t -> Equality.sort -> 'a1
                -> (Equality.sort * 'a1) list -> __ -> __ -> __ -> 'a2 ->
                'a2) -> 'a1 t -> 'a2 **)

            let remove_rec =
              remove_rect

            (** val coq_R_remove_correct :
                key -> 'a1 t -> 'a1 t -> 'a1 coq_R_remove **)

            let coq_R_remove_correct k s _res =
              Obj.magic remove_rect k (fun y _ _ _ -> R_remove_0 y)
                (fun y y0 y1 y2 _ _ _ _ _ -> R_remove_1 (y, y0, y1, y2))
                (fun y y0 y1 y2 _ _ _ _ _ -> R_remove_2 (y, y0, y1, y2))
                (fun y y0 y1 y2 _ _ _ y6 _ _ -> R_remove_3 (y, y0, y1, y2,
                (remove k y2), (y6 (remove k y2) __))) s _res __

            (** val elements : 'a1 t -> 'a1 t **)

            let elements m =
              m

            (** val fold :
                (key -> 'a1 -> 'a2 -> 'a2) -> 'a1 t -> 'a2 -> 'a2 **)

            let rec fold f m acc0 =
              match m with
              | [] -> acc0
              | p :: m' -> let (k, e) = p in fold f m' (f k e acc0)

            type ('elt, 'a) coq_R_fold =
            | R_fold_0 of 'elt t * 'a
            | R_fold_1 of 'elt t * 'a * Equality.sort * 'elt
               * (Equality.sort * 'elt) list * 'a * ('elt, 'a) coq_R_fold

            (** val coq_R_fold_rect :
                (key -> 'a1 -> 'a2 -> 'a2) -> ('a1 t -> 'a2 -> __ -> 'a3) ->
                ('a1 t -> 'a2 -> Equality.sort -> 'a1 ->
                (Equality.sort * 'a1) list -> __ -> 'a2 -> ('a1, 'a2)
                coq_R_fold -> 'a3 -> 'a3) -> 'a1 t -> 'a2 -> 'a2 -> ('a1,
                'a2) coq_R_fold -> 'a3 **)

            let rec coq_R_fold_rect f f0 f1 _ _ _ = function
            | R_fold_0 (m, acc0) -> f0 m acc0 __
            | R_fold_1 (m, acc0, k, e, m', _res, r0) ->
              f1 m acc0 k e m' __ _res r0
                (coq_R_fold_rect f f0 f1 m' (f k e acc0) _res r0)

            (** val coq_R_fold_rec :
                (key -> 'a1 -> 'a2 -> 'a2) -> ('a1 t -> 'a2 -> __ -> 'a3) ->
                ('a1 t -> 'a2 -> Equality.sort -> 'a1 ->
                (Equality.sort * 'a1) list -> __ -> 'a2 -> ('a1, 'a2)
                coq_R_fold -> 'a3 -> 'a3) -> 'a1 t -> 'a2 -> 'a2 -> ('a1,
                'a2) coq_R_fold -> 'a3 **)

            let rec coq_R_fold_rec f f0 f1 _ _ _ = function
            | R_fold_0 (m, acc0) -> f0 m acc0 __
            | R_fold_1 (m, acc0, k, e, m', _res, r0) ->
              f1 m acc0 k e m' __ _res r0
                (coq_R_fold_rec f f0 f1 m' (f k e acc0) _res r0)

            (** val fold_rect :
                (key -> 'a1 -> 'a2 -> 'a2) -> ('a1 t -> 'a2 -> __ -> 'a3) ->
                ('a1 t -> 'a2 -> Equality.sort -> 'a1 ->
                (Equality.sort * 'a1) list -> __ -> 'a3 -> 'a3) -> 'a1 t ->
                'a2 -> 'a3 **)

            let rec fold_rect f f0 f1 m acc0 =
              let f2 = f0 m acc0 in
              let f3 = f1 m acc0 in
              (match m with
               | [] -> f2 __
               | a :: l ->
                 let (a0, b) = a in
                 let f4 = f3 a0 b l __ in
                 let hrec = fold_rect f f0 f1 l (f a0 b acc0) in f4 hrec)

            (** val fold_rec :
                (key -> 'a1 -> 'a2 -> 'a2) -> ('a1 t -> 'a2 -> __ -> 'a3) ->
                ('a1 t -> 'a2 -> Equality.sort -> 'a1 ->
                (Equality.sort * 'a1) list -> __ -> 'a3 -> 'a3) -> 'a1 t ->
                'a2 -> 'a3 **)

            let fold_rec =
              fold_rect

            (** val coq_R_fold_correct :
                (key -> 'a1 -> 'a2 -> 'a2) -> 'a1 t -> 'a2 -> 'a2 -> ('a1,
                'a2) coq_R_fold **)

            let coq_R_fold_correct f m acc0 _res =
              fold_rect f (fun y y0 _ _ _ -> R_fold_0 (y, y0))
                (fun y y0 y1 y2 y3 _ y5 _ _ -> R_fold_1 (y, y0, y1, y2, y3,
                (fold f y3 (f y1 y2 y0)), (y5 (fold f y3 (f y1 y2 y0)) __)))
                m acc0 _res __

            (** val equal : ('a1 -> 'a1 -> bool) -> 'a1 t -> 'a1 t -> bool **)

            let rec equal cmp m m' =
              match m with
              | [] -> (match m' with
                       | [] -> true
                       | _ :: _ -> false)
              | p :: l ->
                let (x, e) = p in
                (match m' with
                 | [] -> false
                 | p0 :: l' ->
                   let (x', e') = p0 in
                   (match V.compare x x' with
                    | OrderedType.EQ -> (&&) (cmp e e') (equal cmp l l')
                    | _ -> false))

            type 'elt coq_R_equal =
            | R_equal_0 of 'elt t * 'elt t
            | R_equal_1 of 'elt t * 'elt t * Equality.sort * 'elt
               * (Equality.sort * 'elt) list * Equality.sort * 'elt
               * (Equality.sort * 'elt) list * bool * 'elt coq_R_equal
            | R_equal_2 of 'elt t * 'elt t * Equality.sort * 'elt
               * (Equality.sort * 'elt) list * Equality.sort * 'elt
               * (Equality.sort * 'elt) list
               * Equality.sort OrderedType.coq_Compare
            | R_equal_3 of 'elt t * 'elt t * 'elt t * 'elt t

            (** val coq_R_equal_rect :
                ('a1 -> 'a1 -> bool) -> ('a1 t -> 'a1 t -> __ -> __ -> 'a2)
                -> ('a1 t -> 'a1 t -> Equality.sort -> 'a1 ->
                (Equality.sort * 'a1) list -> __ -> Equality.sort -> 'a1 ->
                (Equality.sort * 'a1) list -> __ -> __ -> __ -> bool -> 'a1
                coq_R_equal -> 'a2 -> 'a2) -> ('a1 t -> 'a1 t ->
                Equality.sort -> 'a1 -> (Equality.sort * 'a1) list -> __ ->
                Equality.sort -> 'a1 -> (Equality.sort * 'a1) list -> __ ->
                Equality.sort OrderedType.coq_Compare -> __ -> __ -> 'a2) ->
                ('a1 t -> 'a1 t -> 'a1 t -> __ -> 'a1 t -> __ -> __ -> 'a2)
                -> 'a1 t -> 'a1 t -> bool -> 'a1 coq_R_equal -> 'a2 **)

            let rec coq_R_equal_rect cmp f f0 f1 f2 _ _ _ = function
            | R_equal_0 (m, m') -> f m m' __ __
            | R_equal_1 (m, m', x, e, l, x', e', l', _res, r0) ->
              f0 m m' x e l __ x' e' l' __ __ __ _res r0
                (coq_R_equal_rect cmp f f0 f1 f2 l l' _res r0)
            | R_equal_2 (m, m', x, e, l, x', e', l', _x) ->
              f1 m m' x e l __ x' e' l' __ _x __ __
            | R_equal_3 (m, m', _x, _x0) -> f2 m m' _x __ _x0 __ __

            (** val coq_R_equal_rec :
                ('a1 -> 'a1 -> bool) -> ('a1 t -> 'a1 t -> __ -> __ -> 'a2)
                -> ('a1 t -> 'a1 t -> Equality.sort -> 'a1 ->
                (Equality.sort * 'a1) list -> __ -> Equality.sort -> 'a1 ->
                (Equality.sort * 'a1) list -> __ -> __ -> __ -> bool -> 'a1
                coq_R_equal -> 'a2 -> 'a2) -> ('a1 t -> 'a1 t ->
                Equality.sort -> 'a1 -> (Equality.sort * 'a1) list -> __ ->
                Equality.sort -> 'a1 -> (Equality.sort * 'a1) list -> __ ->
                Equality.sort OrderedType.coq_Compare -> __ -> __ -> 'a2) ->
                ('a1 t -> 'a1 t -> 'a1 t -> __ -> 'a1 t -> __ -> __ -> 'a2)
                -> 'a1 t -> 'a1 t -> bool -> 'a1 coq_R_equal -> 'a2 **)

            let rec coq_R_equal_rec cmp f f0 f1 f2 _ _ _ = function
            | R_equal_0 (m, m') -> f m m' __ __
            | R_equal_1 (m, m', x, e, l, x', e', l', _res, r0) ->
              f0 m m' x e l __ x' e' l' __ __ __ _res r0
                (coq_R_equal_rec cmp f f0 f1 f2 l l' _res r0)
            | R_equal_2 (m, m', x, e, l, x', e', l', _x) ->
              f1 m m' x e l __ x' e' l' __ _x __ __
            | R_equal_3 (m, m', _x, _x0) -> f2 m m' _x __ _x0 __ __

            (** val equal_rect :
                ('a1 -> 'a1 -> bool) -> ('a1 t -> 'a1 t -> __ -> __ -> 'a2)
                -> ('a1 t -> 'a1 t -> Equality.sort -> 'a1 ->
                (Equality.sort * 'a1) list -> __ -> Equality.sort -> 'a1 ->
                (Equality.sort * 'a1) list -> __ -> __ -> __ -> 'a2 -> 'a2)
                -> ('a1 t -> 'a1 t -> Equality.sort -> 'a1 ->
                (Equality.sort * 'a1) list -> __ -> Equality.sort -> 'a1 ->
                (Equality.sort * 'a1) list -> __ -> Equality.sort
                OrderedType.coq_Compare -> __ -> __ -> 'a2) -> ('a1 t -> 'a1
                t -> 'a1 t -> __ -> 'a1 t -> __ -> __ -> 'a2) -> 'a1 t -> 'a1
                t -> 'a2 **)

            let rec equal_rect cmp f f0 f1 f2 m m' =
              let f3 = f m m' in
              let f4 = f0 m m' in
              let f5 = f1 m m' in
              let f6 = f2 m m' in
              let f7 = f6 m __ in
              let f8 = f7 m' __ in
              (match m with
               | [] ->
                 let f9 = f3 __ in
                 (match m' with
                  | [] -> f9 __
                  | _ :: _ -> f8 __)
               | a :: l ->
                 let (a0, b) = a in
                 let f9 = f5 a0 b l __ in
                 let f10 = f4 a0 b l __ in
                 (match m' with
                  | [] -> f8 __
                  | a1 :: l0 ->
                    let (a2, b0) = a1 in
                    let f11 = f9 a2 b0 l0 __ in
                    let f12 = let _x = V.compare a0 a2 in f11 _x __ in
                    let f13 = f10 a2 b0 l0 __ in
                    let f14 = fun _ _ ->
                      let hrec = equal_rect cmp f f0 f1 f2 l l0 in
                      f13 __ __ hrec
                    in
                    (match V.compare a0 a2 with
                     | OrderedType.EQ -> f14 __ __
                     | _ -> f12 __)))

            (** val equal_rec :
                ('a1 -> 'a1 -> bool) -> ('a1 t -> 'a1 t -> __ -> __ -> 'a2)
                -> ('a1 t -> 'a1 t -> Equality.sort -> 'a1 ->
                (Equality.sort * 'a1) list -> __ -> Equality.sort -> 'a1 ->
                (Equality.sort * 'a1) list -> __ -> __ -> __ -> 'a2 -> 'a2)
                -> ('a1 t -> 'a1 t -> Equality.sort -> 'a1 ->
                (Equality.sort * 'a1) list -> __ -> Equality.sort -> 'a1 ->
                (Equality.sort * 'a1) list -> __ -> Equality.sort
                OrderedType.coq_Compare -> __ -> __ -> 'a2) -> ('a1 t -> 'a1
                t -> 'a1 t -> __ -> 'a1 t -> __ -> __ -> 'a2) -> 'a1 t -> 'a1
                t -> 'a2 **)

            let equal_rec =
              equal_rect

            (** val coq_R_equal_correct :
                ('a1 -> 'a1 -> bool) -> 'a1 t -> 'a1 t -> bool -> 'a1
                coq_R_equal **)

            let coq_R_equal_correct cmp m m' _res =
              equal_rect cmp (fun y y0 _ _ _ _ -> R_equal_0 (y, y0))
                (fun y y0 y1 y2 y3 _ y5 y6 y7 _ _ _ y11 _ _ -> R_equal_1 (y,
                y0, y1, y2, y3, y5, y6, y7, (equal cmp y3 y7),
                (y11 (equal cmp y3 y7) __)))
                (fun y y0 y1 y2 y3 _ y5 y6 y7 _ y9 _ _ _ _ -> R_equal_2 (y,
                y0, y1, y2, y3, y5, y6, y7, y9)) (fun y y0 y1 _ y3 _ _ _ _ ->
                R_equal_3 (y, y0, y1, y3)) m m' _res __

            (** val map : ('a1 -> 'a2) -> 'a1 t -> 'a2 t **)

            let rec map f = function
            | [] -> []
            | p :: m' -> let (k, e) = p in (k, (f e)) :: (map f m')

            (** val mapi : (key -> 'a1 -> 'a2) -> 'a1 t -> 'a2 t **)

            let rec mapi f = function
            | [] -> []
            | p :: m' -> let (k, e) = p in (k, (f k e)) :: (mapi f m')

            (** val option_cons :
                key -> 'a1 option -> (key * 'a1) list -> (key * 'a1) list **)

            let option_cons k o l =
              match o with
              | Some e -> (k, e) :: l
              | None -> l

            (** val map2_l :
                ('a1 option -> 'a2 option -> 'a3 option) -> 'a1 t -> 'a3 t **)

            let rec map2_l f = function
            | [] -> []
            | p :: l ->
              let (k, e) = p in option_cons k (f (Some e) None) (map2_l f l)

            (** val map2_r :
                ('a1 option -> 'a2 option -> 'a3 option) -> 'a2 t -> 'a3 t **)

            let rec map2_r f = function
            | [] -> []
            | p :: l' ->
              let (k, e') = p in
              option_cons k (f None (Some e')) (map2_r f l')

            (** val map2 :
                ('a1 option -> 'a2 option -> 'a3 option) -> 'a1 t -> 'a2 t ->
                'a3 t **)

            let rec map2 f m = match m with
            | [] -> map2_r f
            | p :: l ->
              let (k, e) = p in
              let rec map2_aux m' = match m' with
              | [] -> map2_l f m
              | p0 :: l' ->
                let (k', e') = p0 in
                (match V.compare k k' with
                 | OrderedType.LT ->
                   option_cons k (f (Some e) None) (map2 f l m')
                 | OrderedType.EQ ->
                   option_cons k (f (Some e) (Some e')) (map2 f l l')
                 | OrderedType.GT ->
                   option_cons k' (f None (Some e')) (map2_aux l'))
              in map2_aux

            (** val combine :
                'a1 t -> 'a2 t -> ('a1 option * 'a2 option) t **)

            let rec combine m = match m with
            | [] -> map (fun e' -> (None, (Some e')))
            | p :: l ->
              let (k, e) = p in
              let rec combine_aux m' = match m' with
              | [] -> map (fun e0 -> ((Some e0), None)) m
              | p0 :: l' ->
                let (k', e') = p0 in
                (match V.compare k k' with
                 | OrderedType.LT -> (k, ((Some e), None)) :: (combine l m')
                 | OrderedType.EQ ->
                   (k, ((Some e), (Some e'))) :: (combine l l')
                 | OrderedType.GT ->
                   (k', (None, (Some e'))) :: (combine_aux l'))
              in combine_aux

            (** val fold_right_pair :
                ('a1 -> 'a2 -> 'a3 -> 'a3) -> ('a1 * 'a2) list -> 'a3 -> 'a3 **)

            let fold_right_pair f l i =
              fold_right (fun p -> f (fst p) (snd p)) i l

            (** val map2_alt :
                ('a1 option -> 'a2 option -> 'a3 option) -> 'a1 t -> 'a2 t ->
                (key * 'a3) list **)

            let map2_alt f m m' =
              let m0 = combine m m' in
              let m1 = map (fun p -> f (fst p) (snd p)) m0 in
              fold_right_pair option_cons m1 []

            (** val at_least_one :
                'a1 option -> 'a2 option -> ('a1 option * 'a2 option) option **)

            let at_least_one o o' =
              match o with
              | Some _ -> Some (o, o')
              | None -> (match o' with
                         | Some _ -> Some (o, o')
                         | None -> None)

            (** val at_least_one_then_f :
                ('a1 option -> 'a2 option -> 'a3 option) -> 'a1 option -> 'a2
                option -> 'a3 option **)

            let at_least_one_then_f f o o' =
              match o with
              | Some _ -> f o o'
              | None -> (match o' with
                         | Some _ -> f o o'
                         | None -> None)
           end

          type 'elt coq_R_mem =
          | R_mem_0 of 'elt tree
          | R_mem_1 of 'elt tree * 'elt tree * key * 'elt * 'elt tree
             * Z_as_Int.t * bool * 'elt coq_R_mem
          | R_mem_2 of 'elt tree * 'elt tree * key * 'elt * 'elt tree
             * Z_as_Int.t
          | R_mem_3 of 'elt tree * 'elt tree * key * 'elt * 'elt tree
             * Z_as_Int.t * bool * 'elt coq_R_mem

          (** val coq_R_mem_rect :
              Equality.sort -> ('a1 tree -> __ -> 'a2) -> ('a1 tree -> 'a1
              tree -> key -> 'a1 -> 'a1 tree -> Z_as_Int.t -> __ -> __ -> __
              -> bool -> 'a1 coq_R_mem -> 'a2 -> 'a2) -> ('a1 tree -> 'a1
              tree -> key -> 'a1 -> 'a1 tree -> Z_as_Int.t -> __ -> __ -> __
              -> 'a2) -> ('a1 tree -> 'a1 tree -> key -> 'a1 -> 'a1 tree ->
              Z_as_Int.t -> __ -> __ -> __ -> bool -> 'a1 coq_R_mem -> 'a2 ->
              'a2) -> 'a1 tree -> bool -> 'a1 coq_R_mem -> 'a2 **)

          let rec coq_R_mem_rect x f f0 f1 f2 _ _ = function
          | R_mem_0 m -> f m __
          | R_mem_1 (m, l, y, _x, r0, _x0, _res, r1) ->
            f0 m l y _x r0 _x0 __ __ __ _res r1
              (coq_R_mem_rect x f f0 f1 f2 l _res r1)
          | R_mem_2 (m, l, y, _x, r0, _x0) -> f1 m l y _x r0 _x0 __ __ __
          | R_mem_3 (m, l, y, _x, r0, _x0, _res, r1) ->
            f2 m l y _x r0 _x0 __ __ __ _res r1
              (coq_R_mem_rect x f f0 f1 f2 r0 _res r1)

          (** val coq_R_mem_rec :
              Equality.sort -> ('a1 tree -> __ -> 'a2) -> ('a1 tree -> 'a1
              tree -> key -> 'a1 -> 'a1 tree -> Z_as_Int.t -> __ -> __ -> __
              -> bool -> 'a1 coq_R_mem -> 'a2 -> 'a2) -> ('a1 tree -> 'a1
              tree -> key -> 'a1 -> 'a1 tree -> Z_as_Int.t -> __ -> __ -> __
              -> 'a2) -> ('a1 tree -> 'a1 tree -> key -> 'a1 -> 'a1 tree ->
              Z_as_Int.t -> __ -> __ -> __ -> bool -> 'a1 coq_R_mem -> 'a2 ->
              'a2) -> 'a1 tree -> bool -> 'a1 coq_R_mem -> 'a2 **)

          let rec coq_R_mem_rec x f f0 f1 f2 _ _ = function
          | R_mem_0 m -> f m __
          | R_mem_1 (m, l, y, _x, r0, _x0, _res, r1) ->
            f0 m l y _x r0 _x0 __ __ __ _res r1
              (coq_R_mem_rec x f f0 f1 f2 l _res r1)
          | R_mem_2 (m, l, y, _x, r0, _x0) -> f1 m l y _x r0 _x0 __ __ __
          | R_mem_3 (m, l, y, _x, r0, _x0, _res, r1) ->
            f2 m l y _x r0 _x0 __ __ __ _res r1
              (coq_R_mem_rec x f f0 f1 f2 r0 _res r1)

          type 'elt coq_R_find =
          | R_find_0 of 'elt tree
          | R_find_1 of 'elt tree * 'elt tree * key * 'elt * 'elt tree
             * Z_as_Int.t * 'elt option * 'elt coq_R_find
          | R_find_2 of 'elt tree * 'elt tree * key * 'elt * 'elt tree
             * Z_as_Int.t
          | R_find_3 of 'elt tree * 'elt tree * key * 'elt * 'elt tree
             * Z_as_Int.t * 'elt option * 'elt coq_R_find

          (** val coq_R_find_rect :
              Equality.sort -> ('a1 tree -> __ -> 'a2) -> ('a1 tree -> 'a1
              tree -> key -> 'a1 -> 'a1 tree -> Z_as_Int.t -> __ -> __ -> __
              -> 'a1 option -> 'a1 coq_R_find -> 'a2 -> 'a2) -> ('a1 tree ->
              'a1 tree -> key -> 'a1 -> 'a1 tree -> Z_as_Int.t -> __ -> __ ->
              __ -> 'a2) -> ('a1 tree -> 'a1 tree -> key -> 'a1 -> 'a1 tree
              -> Z_as_Int.t -> __ -> __ -> __ -> 'a1 option -> 'a1 coq_R_find
              -> 'a2 -> 'a2) -> 'a1 tree -> 'a1 option -> 'a1 coq_R_find ->
              'a2 **)

          let rec coq_R_find_rect x f f0 f1 f2 _ _ = function
          | R_find_0 m -> f m __
          | R_find_1 (m, l, y, d, r0, _x, _res, r1) ->
            f0 m l y d r0 _x __ __ __ _res r1
              (coq_R_find_rect x f f0 f1 f2 l _res r1)
          | R_find_2 (m, l, y, d, r0, _x) -> f1 m l y d r0 _x __ __ __
          | R_find_3 (m, l, y, d, r0, _x, _res, r1) ->
            f2 m l y d r0 _x __ __ __ _res r1
              (coq_R_find_rect x f f0 f1 f2 r0 _res r1)

          (** val coq_R_find_rec :
              Equality.sort -> ('a1 tree -> __ -> 'a2) -> ('a1 tree -> 'a1
              tree -> key -> 'a1 -> 'a1 tree -> Z_as_Int.t -> __ -> __ -> __
              -> 'a1 option -> 'a1 coq_R_find -> 'a2 -> 'a2) -> ('a1 tree ->
              'a1 tree -> key -> 'a1 -> 'a1 tree -> Z_as_Int.t -> __ -> __ ->
              __ -> 'a2) -> ('a1 tree -> 'a1 tree -> key -> 'a1 -> 'a1 tree
              -> Z_as_Int.t -> __ -> __ -> __ -> 'a1 option -> 'a1 coq_R_find
              -> 'a2 -> 'a2) -> 'a1 tree -> 'a1 option -> 'a1 coq_R_find ->
              'a2 **)

          let rec coq_R_find_rec x f f0 f1 f2 _ _ = function
          | R_find_0 m -> f m __
          | R_find_1 (m, l, y, d, r0, _x, _res, r1) ->
            f0 m l y d r0 _x __ __ __ _res r1
              (coq_R_find_rec x f f0 f1 f2 l _res r1)
          | R_find_2 (m, l, y, d, r0, _x) -> f1 m l y d r0 _x __ __ __
          | R_find_3 (m, l, y, d, r0, _x, _res, r1) ->
            f2 m l y d r0 _x __ __ __ _res r1
              (coq_R_find_rec x f f0 f1 f2 r0 _res r1)

          type 'elt coq_R_bal =
          | R_bal_0 of 'elt tree * key * 'elt * 'elt tree
          | R_bal_1 of 'elt tree * key * 'elt * 'elt tree * 'elt tree * 
             key * 'elt * 'elt tree * Z_as_Int.t
          | R_bal_2 of 'elt tree * key * 'elt * 'elt tree * 'elt tree * 
             key * 'elt * 'elt tree * Z_as_Int.t
          | R_bal_3 of 'elt tree * key * 'elt * 'elt tree * 'elt tree * 
             key * 'elt * 'elt tree * Z_as_Int.t * 'elt tree * key * 
             'elt * 'elt tree * Z_as_Int.t
          | R_bal_4 of 'elt tree * key * 'elt * 'elt tree
          | R_bal_5 of 'elt tree * key * 'elt * 'elt tree * 'elt tree * 
             key * 'elt * 'elt tree * Z_as_Int.t
          | R_bal_6 of 'elt tree * key * 'elt * 'elt tree * 'elt tree * 
             key * 'elt * 'elt tree * Z_as_Int.t
          | R_bal_7 of 'elt tree * key * 'elt * 'elt tree * 'elt tree * 
             key * 'elt * 'elt tree * Z_as_Int.t * 'elt tree * key * 
             'elt * 'elt tree * Z_as_Int.t
          | R_bal_8 of 'elt tree * key * 'elt * 'elt tree

          (** val coq_R_bal_rect :
              ('a1 tree -> key -> 'a1 -> 'a1 tree -> __ -> __ -> __ -> 'a2)
              -> ('a1 tree -> key -> 'a1 -> 'a1 tree -> __ -> __ -> 'a1 tree
              -> key -> 'a1 -> 'a1 tree -> Z_as_Int.t -> __ -> __ -> __ ->
              'a2) -> ('a1 tree -> key -> 'a1 -> 'a1 tree -> __ -> __ -> 'a1
              tree -> key -> 'a1 -> 'a1 tree -> Z_as_Int.t -> __ -> __ -> __
              -> __ -> 'a2) -> ('a1 tree -> key -> 'a1 -> 'a1 tree -> __ ->
              __ -> 'a1 tree -> key -> 'a1 -> 'a1 tree -> Z_as_Int.t -> __ ->
              __ -> __ -> 'a1 tree -> key -> 'a1 -> 'a1 tree -> Z_as_Int.t ->
              __ -> 'a2) -> ('a1 tree -> key -> 'a1 -> 'a1 tree -> __ -> __
              -> __ -> __ -> __ -> 'a2) -> ('a1 tree -> key -> 'a1 -> 'a1
              tree -> __ -> __ -> __ -> __ -> 'a1 tree -> key -> 'a1 -> 'a1
              tree -> Z_as_Int.t -> __ -> __ -> __ -> 'a2) -> ('a1 tree ->
              key -> 'a1 -> 'a1 tree -> __ -> __ -> __ -> __ -> 'a1 tree ->
              key -> 'a1 -> 'a1 tree -> Z_as_Int.t -> __ -> __ -> __ -> __ ->
              'a2) -> ('a1 tree -> key -> 'a1 -> 'a1 tree -> __ -> __ -> __
              -> __ -> 'a1 tree -> key -> 'a1 -> 'a1 tree -> Z_as_Int.t -> __
              -> __ -> __ -> 'a1 tree -> key -> 'a1 -> 'a1 tree -> Z_as_Int.t
              -> __ -> 'a2) -> ('a1 tree -> key -> 'a1 -> 'a1 tree -> __ ->
              __ -> __ -> __ -> 'a2) -> 'a1 tree -> key -> 'a1 -> 'a1 tree ->
              'a1 tree -> 'a1 coq_R_bal -> 'a2 **)

          let coq_R_bal_rect f f0 f1 f2 f3 f4 f5 f6 f7 _ _ _ _ _ = function
          | R_bal_0 (l, x, d, r) -> f l x d r __ __ __
          | R_bal_1 (l, x, d, r, x0, x1, x2, x3, x4) ->
            f0 l x d r __ __ x0 x1 x2 x3 x4 __ __ __
          | R_bal_2 (l, x, d, r, x0, x1, x2, x3, x4) ->
            f1 l x d r __ __ x0 x1 x2 x3 x4 __ __ __ __
          | R_bal_3 (l, x, d, r, x0, x1, x2, x3, x4, x5, x6, x7, x8, x9) ->
            f2 l x d r __ __ x0 x1 x2 x3 x4 __ __ __ x5 x6 x7 x8 x9 __
          | R_bal_4 (l, x, d, r) -> f3 l x d r __ __ __ __ __
          | R_bal_5 (l, x, d, r, x0, x1, x2, x3, x4) ->
            f4 l x d r __ __ __ __ x0 x1 x2 x3 x4 __ __ __
          | R_bal_6 (l, x, d, r, x0, x1, x2, x3, x4) ->
            f5 l x d r __ __ __ __ x0 x1 x2 x3 x4 __ __ __ __
          | R_bal_7 (l, x, d, r, x0, x1, x2, x3, x4, x5, x6, x7, x8, x9) ->
            f6 l x d r __ __ __ __ x0 x1 x2 x3 x4 __ __ __ x5 x6 x7 x8 x9 __
          | R_bal_8 (l, x, d, r) -> f7 l x d r __ __ __ __

          (** val coq_R_bal_rec :
              ('a1 tree -> key -> 'a1 -> 'a1 tree -> __ -> __ -> __ -> 'a2)
              -> ('a1 tree -> key -> 'a1 -> 'a1 tree -> __ -> __ -> 'a1 tree
              -> key -> 'a1 -> 'a1 tree -> Z_as_Int.t -> __ -> __ -> __ ->
              'a2) -> ('a1 tree -> key -> 'a1 -> 'a1 tree -> __ -> __ -> 'a1
              tree -> key -> 'a1 -> 'a1 tree -> Z_as_Int.t -> __ -> __ -> __
              -> __ -> 'a2) -> ('a1 tree -> key -> 'a1 -> 'a1 tree -> __ ->
              __ -> 'a1 tree -> key -> 'a1 -> 'a1 tree -> Z_as_Int.t -> __ ->
              __ -> __ -> 'a1 tree -> key -> 'a1 -> 'a1 tree -> Z_as_Int.t ->
              __ -> 'a2) -> ('a1 tree -> key -> 'a1 -> 'a1 tree -> __ -> __
              -> __ -> __ -> __ -> 'a2) -> ('a1 tree -> key -> 'a1 -> 'a1
              tree -> __ -> __ -> __ -> __ -> 'a1 tree -> key -> 'a1 -> 'a1
              tree -> Z_as_Int.t -> __ -> __ -> __ -> 'a2) -> ('a1 tree ->
              key -> 'a1 -> 'a1 tree -> __ -> __ -> __ -> __ -> 'a1 tree ->
              key -> 'a1 -> 'a1 tree -> Z_as_Int.t -> __ -> __ -> __ -> __ ->
              'a2) -> ('a1 tree -> key -> 'a1 -> 'a1 tree -> __ -> __ -> __
              -> __ -> 'a1 tree -> key -> 'a1 -> 'a1 tree -> Z_as_Int.t -> __
              -> __ -> __ -> 'a1 tree -> key -> 'a1 -> 'a1 tree -> Z_as_Int.t
              -> __ -> 'a2) -> ('a1 tree -> key -> 'a1 -> 'a1 tree -> __ ->
              __ -> __ -> __ -> 'a2) -> 'a1 tree -> key -> 'a1 -> 'a1 tree ->
              'a1 tree -> 'a1 coq_R_bal -> 'a2 **)

          let coq_R_bal_rec f f0 f1 f2 f3 f4 f5 f6 f7 _ _ _ _ _ = function
          | R_bal_0 (l, x, d, r) -> f l x d r __ __ __
          | R_bal_1 (l, x, d, r, x0, x1, x2, x3, x4) ->
            f0 l x d r __ __ x0 x1 x2 x3 x4 __ __ __
          | R_bal_2 (l, x, d, r, x0, x1, x2, x3, x4) ->
            f1 l x d r __ __ x0 x1 x2 x3 x4 __ __ __ __
          | R_bal_3 (l, x, d, r, x0, x1, x2, x3, x4, x5, x6, x7, x8, x9) ->
            f2 l x d r __ __ x0 x1 x2 x3 x4 __ __ __ x5 x6 x7 x8 x9 __
          | R_bal_4 (l, x, d, r) -> f3 l x d r __ __ __ __ __
          | R_bal_5 (l, x, d, r, x0, x1, x2, x3, x4) ->
            f4 l x d r __ __ __ __ x0 x1 x2 x3 x4 __ __ __
          | R_bal_6 (l, x, d, r, x0, x1, x2, x3, x4) ->
            f5 l x d r __ __ __ __ x0 x1 x2 x3 x4 __ __ __ __
          | R_bal_7 (l, x, d, r, x0, x1, x2, x3, x4, x5, x6, x7, x8, x9) ->
            f6 l x d r __ __ __ __ x0 x1 x2 x3 x4 __ __ __ x5 x6 x7 x8 x9 __
          | R_bal_8 (l, x, d, r) -> f7 l x d r __ __ __ __

          type 'elt coq_R_add =
          | R_add_0 of 'elt tree
          | R_add_1 of 'elt tree * 'elt tree * key * 'elt * 'elt tree
             * Z_as_Int.t * 'elt tree * 'elt coq_R_add
          | R_add_2 of 'elt tree * 'elt tree * key * 'elt * 'elt tree
             * Z_as_Int.t
          | R_add_3 of 'elt tree * 'elt tree * key * 'elt * 'elt tree
             * Z_as_Int.t * 'elt tree * 'elt coq_R_add

          (** val coq_R_add_rect :
              key -> 'a1 -> ('a1 tree -> __ -> 'a2) -> ('a1 tree -> 'a1 tree
              -> key -> 'a1 -> 'a1 tree -> Z_as_Int.t -> __ -> __ -> __ ->
              'a1 tree -> 'a1 coq_R_add -> 'a2 -> 'a2) -> ('a1 tree -> 'a1
              tree -> key -> 'a1 -> 'a1 tree -> Z_as_Int.t -> __ -> __ -> __
              -> 'a2) -> ('a1 tree -> 'a1 tree -> key -> 'a1 -> 'a1 tree ->
              Z_as_Int.t -> __ -> __ -> __ -> 'a1 tree -> 'a1 coq_R_add ->
              'a2 -> 'a2) -> 'a1 tree -> 'a1 tree -> 'a1 coq_R_add -> 'a2 **)

          let rec coq_R_add_rect x d f f0 f1 f2 _ _ = function
          | R_add_0 m -> f m __
          | R_add_1 (m, l, y, d', r0, h, _res, r1) ->
            f0 m l y d' r0 h __ __ __ _res r1
              (coq_R_add_rect x d f f0 f1 f2 l _res r1)
          | R_add_2 (m, l, y, d', r0, h) -> f1 m l y d' r0 h __ __ __
          | R_add_3 (m, l, y, d', r0, h, _res, r1) ->
            f2 m l y d' r0 h __ __ __ _res r1
              (coq_R_add_rect x d f f0 f1 f2 r0 _res r1)

          (** val coq_R_add_rec :
              key -> 'a1 -> ('a1 tree -> __ -> 'a2) -> ('a1 tree -> 'a1 tree
              -> key -> 'a1 -> 'a1 tree -> Z_as_Int.t -> __ -> __ -> __ ->
              'a1 tree -> 'a1 coq_R_add -> 'a2 -> 'a2) -> ('a1 tree -> 'a1
              tree -> key -> 'a1 -> 'a1 tree -> Z_as_Int.t -> __ -> __ -> __
              -> 'a2) -> ('a1 tree -> 'a1 tree -> key -> 'a1 -> 'a1 tree ->
              Z_as_Int.t -> __ -> __ -> __ -> 'a1 tree -> 'a1 coq_R_add ->
              'a2 -> 'a2) -> 'a1 tree -> 'a1 tree -> 'a1 coq_R_add -> 'a2 **)

          let rec coq_R_add_rec x d f f0 f1 f2 _ _ = function
          | R_add_0 m -> f m __
          | R_add_1 (m, l, y, d', r0, h, _res, r1) ->
            f0 m l y d' r0 h __ __ __ _res r1
              (coq_R_add_rec x d f f0 f1 f2 l _res r1)
          | R_add_2 (m, l, y, d', r0, h) -> f1 m l y d' r0 h __ __ __
          | R_add_3 (m, l, y, d', r0, h, _res, r1) ->
            f2 m l y d' r0 h __ __ __ _res r1
              (coq_R_add_rec x d f f0 f1 f2 r0 _res r1)

          type 'elt coq_R_remove_min =
          | R_remove_min_0 of 'elt tree * key * 'elt * 'elt tree
          | R_remove_min_1 of 'elt tree * key * 'elt * 'elt tree * 'elt tree
             * key * 'elt * 'elt tree * Z_as_Int.t
             * ('elt tree * (key * 'elt)) * 'elt coq_R_remove_min * 'elt tree
             * (key * 'elt)

          (** val coq_R_remove_min_rect :
              ('a1 tree -> key -> 'a1 -> 'a1 tree -> __ -> 'a2) -> ('a1 tree
              -> key -> 'a1 -> 'a1 tree -> 'a1 tree -> key -> 'a1 -> 'a1 tree
              -> Z_as_Int.t -> __ -> ('a1 tree * (key * 'a1)) -> 'a1
              coq_R_remove_min -> 'a2 -> 'a1 tree -> (key * 'a1) -> __ ->
              'a2) -> 'a1 tree -> key -> 'a1 -> 'a1 tree -> ('a1
              tree * (key * 'a1)) -> 'a1 coq_R_remove_min -> 'a2 **)

          let rec coq_R_remove_min_rect f f0 _ _ _ _ _ = function
          | R_remove_min_0 (l, x, d, r) -> f l x d r __
          | R_remove_min_1 (l, x, d, r, ll, lx, ld, lr, _x, _res, r1, l', m) ->
            f0 l x d r ll lx ld lr _x __ _res r1
              (coq_R_remove_min_rect f f0 ll lx ld lr _res r1) l' m __

          (** val coq_R_remove_min_rec :
              ('a1 tree -> key -> 'a1 -> 'a1 tree -> __ -> 'a2) -> ('a1 tree
              -> key -> 'a1 -> 'a1 tree -> 'a1 tree -> key -> 'a1 -> 'a1 tree
              -> Z_as_Int.t -> __ -> ('a1 tree * (key * 'a1)) -> 'a1
              coq_R_remove_min -> 'a2 -> 'a1 tree -> (key * 'a1) -> __ ->
              'a2) -> 'a1 tree -> key -> 'a1 -> 'a1 tree -> ('a1
              tree * (key * 'a1)) -> 'a1 coq_R_remove_min -> 'a2 **)

          let rec coq_R_remove_min_rec f f0 _ _ _ _ _ = function
          | R_remove_min_0 (l, x, d, r) -> f l x d r __
          | R_remove_min_1 (l, x, d, r, ll, lx, ld, lr, _x, _res, r1, l', m) ->
            f0 l x d r ll lx ld lr _x __ _res r1
              (coq_R_remove_min_rec f f0 ll lx ld lr _res r1) l' m __

          type 'elt coq_R_merge =
          | R_merge_0 of 'elt tree * 'elt tree
          | R_merge_1 of 'elt tree * 'elt tree * 'elt tree * key * 'elt
             * 'elt tree * Z_as_Int.t
          | R_merge_2 of 'elt tree * 'elt tree * 'elt tree * key * 'elt
             * 'elt tree * Z_as_Int.t * 'elt tree * key * 'elt * 'elt tree
             * Z_as_Int.t * 'elt tree * (key * 'elt) * key * 'elt

          (** val coq_R_merge_rect :
              ('a1 tree -> 'a1 tree -> __ -> 'a2) -> ('a1 tree -> 'a1 tree ->
              'a1 tree -> key -> 'a1 -> 'a1 tree -> Z_as_Int.t -> __ -> __ ->
              'a2) -> ('a1 tree -> 'a1 tree -> 'a1 tree -> key -> 'a1 -> 'a1
              tree -> Z_as_Int.t -> __ -> 'a1 tree -> key -> 'a1 -> 'a1 tree
              -> Z_as_Int.t -> __ -> 'a1 tree -> (key * 'a1) -> __ -> key ->
              'a1 -> __ -> 'a2) -> 'a1 tree -> 'a1 tree -> 'a1 tree -> 'a1
              coq_R_merge -> 'a2 **)

          let coq_R_merge_rect f f0 f1 _ _ _ = function
          | R_merge_0 (s1, s2) -> f s1 s2 __
          | R_merge_1 (s1, s2, _x, _x0, _x1, _x2, _x3) ->
            f0 s1 s2 _x _x0 _x1 _x2 _x3 __ __
          | R_merge_2 (s1, s2, _x, _x0, _x1, _x2, _x3, l2, x2, d2, r2, _x4,
                       s2', p, x, d) ->
            f1 s1 s2 _x _x0 _x1 _x2 _x3 __ l2 x2 d2 r2 _x4 __ s2' p __ x d __

          (** val coq_R_merge_rec :
              ('a1 tree -> 'a1 tree -> __ -> 'a2) -> ('a1 tree -> 'a1 tree ->
              'a1 tree -> key -> 'a1 -> 'a1 tree -> Z_as_Int.t -> __ -> __ ->
              'a2) -> ('a1 tree -> 'a1 tree -> 'a1 tree -> key -> 'a1 -> 'a1
              tree -> Z_as_Int.t -> __ -> 'a1 tree -> key -> 'a1 -> 'a1 tree
              -> Z_as_Int.t -> __ -> 'a1 tree -> (key * 'a1) -> __ -> key ->
              'a1 -> __ -> 'a2) -> 'a1 tree -> 'a1 tree -> 'a1 tree -> 'a1
              coq_R_merge -> 'a2 **)

          let coq_R_merge_rec f f0 f1 _ _ _ = function
          | R_merge_0 (s1, s2) -> f s1 s2 __
          | R_merge_1 (s1, s2, _x, _x0, _x1, _x2, _x3) ->
            f0 s1 s2 _x _x0 _x1 _x2 _x3 __ __
          | R_merge_2 (s1, s2, _x, _x0, _x1, _x2, _x3, l2, x2, d2, r2, _x4,
                       s2', p, x, d) ->
            f1 s1 s2 _x _x0 _x1 _x2 _x3 __ l2 x2 d2 r2 _x4 __ s2' p __ x d __

          type 'elt coq_R_remove =
          | R_remove_0 of 'elt tree
          | R_remove_1 of 'elt tree * 'elt tree * key * 'elt * 'elt tree
             * Z_as_Int.t * 'elt tree * 'elt coq_R_remove
          | R_remove_2 of 'elt tree * 'elt tree * key * 'elt * 'elt tree
             * Z_as_Int.t
          | R_remove_3 of 'elt tree * 'elt tree * key * 'elt * 'elt tree
             * Z_as_Int.t * 'elt tree * 'elt coq_R_remove

          (** val coq_R_remove_rect :
              Equality.sort -> ('a1 tree -> __ -> 'a2) -> ('a1 tree -> 'a1
              tree -> key -> 'a1 -> 'a1 tree -> Z_as_Int.t -> __ -> __ -> __
              -> 'a1 tree -> 'a1 coq_R_remove -> 'a2 -> 'a2) -> ('a1 tree ->
              'a1 tree -> key -> 'a1 -> 'a1 tree -> Z_as_Int.t -> __ -> __ ->
              __ -> 'a2) -> ('a1 tree -> 'a1 tree -> key -> 'a1 -> 'a1 tree
              -> Z_as_Int.t -> __ -> __ -> __ -> 'a1 tree -> 'a1 coq_R_remove
              -> 'a2 -> 'a2) -> 'a1 tree -> 'a1 tree -> 'a1 coq_R_remove ->
              'a2 **)

          let rec coq_R_remove_rect x f f0 f1 f2 _ _ = function
          | R_remove_0 m -> f m __
          | R_remove_1 (m, l, y, d, r0, _x, _res, r1) ->
            f0 m l y d r0 _x __ __ __ _res r1
              (coq_R_remove_rect x f f0 f1 f2 l _res r1)
          | R_remove_2 (m, l, y, d, r0, _x) -> f1 m l y d r0 _x __ __ __
          | R_remove_3 (m, l, y, d, r0, _x, _res, r1) ->
            f2 m l y d r0 _x __ __ __ _res r1
              (coq_R_remove_rect x f f0 f1 f2 r0 _res r1)

          (** val coq_R_remove_rec :
              Equality.sort -> ('a1 tree -> __ -> 'a2) -> ('a1 tree -> 'a1
              tree -> key -> 'a1 -> 'a1 tree -> Z_as_Int.t -> __ -> __ -> __
              -> 'a1 tree -> 'a1 coq_R_remove -> 'a2 -> 'a2) -> ('a1 tree ->
              'a1 tree -> key -> 'a1 -> 'a1 tree -> Z_as_Int.t -> __ -> __ ->
              __ -> 'a2) -> ('a1 tree -> 'a1 tree -> key -> 'a1 -> 'a1 tree
              -> Z_as_Int.t -> __ -> __ -> __ -> 'a1 tree -> 'a1 coq_R_remove
              -> 'a2 -> 'a2) -> 'a1 tree -> 'a1 tree -> 'a1 coq_R_remove ->
              'a2 **)

          let rec coq_R_remove_rec x f f0 f1 f2 _ _ = function
          | R_remove_0 m -> f m __
          | R_remove_1 (m, l, y, d, r0, _x, _res, r1) ->
            f0 m l y d r0 _x __ __ __ _res r1
              (coq_R_remove_rec x f f0 f1 f2 l _res r1)
          | R_remove_2 (m, l, y, d, r0, _x) -> f1 m l y d r0 _x __ __ __
          | R_remove_3 (m, l, y, d, r0, _x, _res, r1) ->
            f2 m l y d r0 _x __ __ __ _res r1
              (coq_R_remove_rec x f f0 f1 f2 r0 _res r1)

          type 'elt coq_R_concat =
          | R_concat_0 of 'elt tree * 'elt tree
          | R_concat_1 of 'elt tree * 'elt tree * 'elt tree * key * 'elt
             * 'elt tree * Z_as_Int.t
          | R_concat_2 of 'elt tree * 'elt tree * 'elt tree * key * 'elt
             * 'elt tree * Z_as_Int.t * 'elt tree * key * 'elt * 'elt tree
             * Z_as_Int.t * 'elt tree * (key * 'elt)

          (** val coq_R_concat_rect :
              ('a1 tree -> 'a1 tree -> __ -> 'a2) -> ('a1 tree -> 'a1 tree ->
              'a1 tree -> key -> 'a1 -> 'a1 tree -> Z_as_Int.t -> __ -> __ ->
              'a2) -> ('a1 tree -> 'a1 tree -> 'a1 tree -> key -> 'a1 -> 'a1
              tree -> Z_as_Int.t -> __ -> 'a1 tree -> key -> 'a1 -> 'a1 tree
              -> Z_as_Int.t -> __ -> 'a1 tree -> (key * 'a1) -> __ -> 'a2) ->
              'a1 tree -> 'a1 tree -> 'a1 tree -> 'a1 coq_R_concat -> 'a2 **)

          let coq_R_concat_rect f f0 f1 _ _ _ = function
          | R_concat_0 (m1, m2) -> f m1 m2 __
          | R_concat_1 (m1, m2, _x, _x0, _x1, _x2, _x3) ->
            f0 m1 m2 _x _x0 _x1 _x2 _x3 __ __
          | R_concat_2 (m1, m2, _x, _x0, _x1, _x2, _x3, l2, x2, d2, r2, _x4,
                        m2', xd) ->
            f1 m1 m2 _x _x0 _x1 _x2 _x3 __ l2 x2 d2 r2 _x4 __ m2' xd __

          (** val coq_R_concat_rec :
              ('a1 tree -> 'a1 tree -> __ -> 'a2) -> ('a1 tree -> 'a1 tree ->
              'a1 tree -> key -> 'a1 -> 'a1 tree -> Z_as_Int.t -> __ -> __ ->
              'a2) -> ('a1 tree -> 'a1 tree -> 'a1 tree -> key -> 'a1 -> 'a1
              tree -> Z_as_Int.t -> __ -> 'a1 tree -> key -> 'a1 -> 'a1 tree
              -> Z_as_Int.t -> __ -> 'a1 tree -> (key * 'a1) -> __ -> 'a2) ->
              'a1 tree -> 'a1 tree -> 'a1 tree -> 'a1 coq_R_concat -> 'a2 **)

          let coq_R_concat_rec f f0 f1 _ _ _ = function
          | R_concat_0 (m1, m2) -> f m1 m2 __
          | R_concat_1 (m1, m2, _x, _x0, _x1, _x2, _x3) ->
            f0 m1 m2 _x _x0 _x1 _x2 _x3 __ __
          | R_concat_2 (m1, m2, _x, _x0, _x1, _x2, _x3, l2, x2, d2, r2, _x4,
                        m2', xd) ->
            f1 m1 m2 _x _x0 _x1 _x2 _x3 __ l2 x2 d2 r2 _x4 __ m2' xd __

          type 'elt coq_R_split =
          | R_split_0 of 'elt tree
          | R_split_1 of 'elt tree * 'elt tree * key * 'elt * 'elt tree
             * Z_as_Int.t * 'elt triple * 'elt coq_R_split * 'elt tree
             * 'elt option * 'elt tree
          | R_split_2 of 'elt tree * 'elt tree * key * 'elt * 'elt tree
             * Z_as_Int.t
          | R_split_3 of 'elt tree * 'elt tree * key * 'elt * 'elt tree
             * Z_as_Int.t * 'elt triple * 'elt coq_R_split * 'elt tree
             * 'elt option * 'elt tree

          (** val coq_R_split_rect :
              Equality.sort -> ('a1 tree -> __ -> 'a2) -> ('a1 tree -> 'a1
              tree -> key -> 'a1 -> 'a1 tree -> Z_as_Int.t -> __ -> __ -> __
              -> 'a1 triple -> 'a1 coq_R_split -> 'a2 -> 'a1 tree -> 'a1
              option -> 'a1 tree -> __ -> 'a2) -> ('a1 tree -> 'a1 tree ->
              key -> 'a1 -> 'a1 tree -> Z_as_Int.t -> __ -> __ -> __ -> 'a2)
              -> ('a1 tree -> 'a1 tree -> key -> 'a1 -> 'a1 tree ->
              Z_as_Int.t -> __ -> __ -> __ -> 'a1 triple -> 'a1 coq_R_split
              -> 'a2 -> 'a1 tree -> 'a1 option -> 'a1 tree -> __ -> 'a2) ->
              'a1 tree -> 'a1 triple -> 'a1 coq_R_split -> 'a2 **)

          let rec coq_R_split_rect x f f0 f1 f2 _ _ = function
          | R_split_0 m -> f m __
          | R_split_1 (m, l, y, d, r0, _x, _res, r1, ll, o, rl) ->
            f0 m l y d r0 _x __ __ __ _res r1
              (coq_R_split_rect x f f0 f1 f2 l _res r1) ll o rl __
          | R_split_2 (m, l, y, d, r0, _x) -> f1 m l y d r0 _x __ __ __
          | R_split_3 (m, l, y, d, r0, _x, _res, r1, rl, o, rr) ->
            f2 m l y d r0 _x __ __ __ _res r1
              (coq_R_split_rect x f f0 f1 f2 r0 _res r1) rl o rr __

          (** val coq_R_split_rec :
              Equality.sort -> ('a1 tree -> __ -> 'a2) -> ('a1 tree -> 'a1
              tree -> key -> 'a1 -> 'a1 tree -> Z_as_Int.t -> __ -> __ -> __
              -> 'a1 triple -> 'a1 coq_R_split -> 'a2 -> 'a1 tree -> 'a1
              option -> 'a1 tree -> __ -> 'a2) -> ('a1 tree -> 'a1 tree ->
              key -> 'a1 -> 'a1 tree -> Z_as_Int.t -> __ -> __ -> __ -> 'a2)
              -> ('a1 tree -> 'a1 tree -> key -> 'a1 -> 'a1 tree ->
              Z_as_Int.t -> __ -> __ -> __ -> 'a1 triple -> 'a1 coq_R_split
              -> 'a2 -> 'a1 tree -> 'a1 option -> 'a1 tree -> __ -> 'a2) ->
              'a1 tree -> 'a1 triple -> 'a1 coq_R_split -> 'a2 **)

          let rec coq_R_split_rec x f f0 f1 f2 _ _ = function
          | R_split_0 m -> f m __
          | R_split_1 (m, l, y, d, r0, _x, _res, r1, ll, o, rl) ->
            f0 m l y d r0 _x __ __ __ _res r1
              (coq_R_split_rec x f f0 f1 f2 l _res r1) ll o rl __
          | R_split_2 (m, l, y, d, r0, _x) -> f1 m l y d r0 _x __ __ __
          | R_split_3 (m, l, y, d, r0, _x, _res, r1, rl, o, rr) ->
            f2 m l y d r0 _x __ __ __ _res r1
              (coq_R_split_rec x f f0 f1 f2 r0 _res r1) rl o rr __

          type ('elt, 'x) coq_R_map_option =
          | R_map_option_0 of 'elt tree
          | R_map_option_1 of 'elt tree * 'elt tree * key * 'elt * 'elt tree
             * Z_as_Int.t * 'x * 'x tree * ('elt, 'x) coq_R_map_option
             * 'x tree * ('elt, 'x) coq_R_map_option
          | R_map_option_2 of 'elt tree * 'elt tree * key * 'elt * 'elt tree
             * Z_as_Int.t * 'x tree * ('elt, 'x) coq_R_map_option * 'x tree
             * ('elt, 'x) coq_R_map_option

          (** val coq_R_map_option_rect :
              (key -> 'a1 -> 'a2 option) -> ('a1 tree -> __ -> 'a3) -> ('a1
              tree -> 'a1 tree -> key -> 'a1 -> 'a1 tree -> Z_as_Int.t -> __
              -> 'a2 -> __ -> 'a2 tree -> ('a1, 'a2) coq_R_map_option -> 'a3
              -> 'a2 tree -> ('a1, 'a2) coq_R_map_option -> 'a3 -> 'a3) ->
              ('a1 tree -> 'a1 tree -> key -> 'a1 -> 'a1 tree -> Z_as_Int.t
              -> __ -> __ -> 'a2 tree -> ('a1, 'a2) coq_R_map_option -> 'a3
              -> 'a2 tree -> ('a1, 'a2) coq_R_map_option -> 'a3 -> 'a3) ->
              'a1 tree -> 'a2 tree -> ('a1, 'a2) coq_R_map_option -> 'a3 **)

          let rec coq_R_map_option_rect f f0 f1 f2 _ _ = function
          | R_map_option_0 m -> f0 m __
          | R_map_option_1 (m, l, x, d, r0, _x, d', _res0, r1, _res, r2) ->
            f1 m l x d r0 _x __ d' __ _res0 r1
              (coq_R_map_option_rect f f0 f1 f2 l _res0 r1) _res r2
              (coq_R_map_option_rect f f0 f1 f2 r0 _res r2)
          | R_map_option_2 (m, l, x, d, r0, _x, _res0, r1, _res, r2) ->
            f2 m l x d r0 _x __ __ _res0 r1
              (coq_R_map_option_rect f f0 f1 f2 l _res0 r1) _res r2
              (coq_R_map_option_rect f f0 f1 f2 r0 _res r2)

          (** val coq_R_map_option_rec :
              (key -> 'a1 -> 'a2 option) -> ('a1 tree -> __ -> 'a3) -> ('a1
              tree -> 'a1 tree -> key -> 'a1 -> 'a1 tree -> Z_as_Int.t -> __
              -> 'a2 -> __ -> 'a2 tree -> ('a1, 'a2) coq_R_map_option -> 'a3
              -> 'a2 tree -> ('a1, 'a2) coq_R_map_option -> 'a3 -> 'a3) ->
              ('a1 tree -> 'a1 tree -> key -> 'a1 -> 'a1 tree -> Z_as_Int.t
              -> __ -> __ -> 'a2 tree -> ('a1, 'a2) coq_R_map_option -> 'a3
              -> 'a2 tree -> ('a1, 'a2) coq_R_map_option -> 'a3 -> 'a3) ->
              'a1 tree -> 'a2 tree -> ('a1, 'a2) coq_R_map_option -> 'a3 **)

          let rec coq_R_map_option_rec f f0 f1 f2 _ _ = function
          | R_map_option_0 m -> f0 m __
          | R_map_option_1 (m, l, x, d, r0, _x, d', _res0, r1, _res, r2) ->
            f1 m l x d r0 _x __ d' __ _res0 r1
              (coq_R_map_option_rec f f0 f1 f2 l _res0 r1) _res r2
              (coq_R_map_option_rec f f0 f1 f2 r0 _res r2)
          | R_map_option_2 (m, l, x, d, r0, _x, _res0, r1, _res, r2) ->
            f2 m l x d r0 _x __ __ _res0 r1
              (coq_R_map_option_rec f f0 f1 f2 l _res0 r1) _res r2
              (coq_R_map_option_rec f f0 f1 f2 r0 _res r2)

          type ('elt, 'x0, 'x) coq_R_map2_opt =
          | R_map2_opt_0 of 'elt tree * 'x0 tree
          | R_map2_opt_1 of 'elt tree * 'x0 tree * 'elt tree * key * 
             'elt * 'elt tree * Z_as_Int.t
          | R_map2_opt_2 of 'elt tree * 'x0 tree * 'elt tree * key * 
             'elt * 'elt tree * Z_as_Int.t * 'x0 tree * key * 'x0 * 'x0 tree
             * Z_as_Int.t * 'x0 tree * 'x0 option * 'x0 tree * 'x * 'x tree
             * ('elt, 'x0, 'x) coq_R_map2_opt * 'x tree
             * ('elt, 'x0, 'x) coq_R_map2_opt
          | R_map2_opt_3 of 'elt tree * 'x0 tree * 'elt tree * key * 
             'elt * 'elt tree * Z_as_Int.t * 'x0 tree * key * 'x0 * 'x0 tree
             * Z_as_Int.t * 'x0 tree * 'x0 option * 'x0 tree * 'x tree
             * ('elt, 'x0, 'x) coq_R_map2_opt * 'x tree
             * ('elt, 'x0, 'x) coq_R_map2_opt

          (** val coq_R_map2_opt_rect :
              (key -> 'a1 -> 'a2 option -> 'a3 option) -> ('a1 tree -> 'a3
              tree) -> ('a2 tree -> 'a3 tree) -> ('a1 tree -> 'a2 tree -> __
              -> 'a4) -> ('a1 tree -> 'a2 tree -> 'a1 tree -> key -> 'a1 ->
              'a1 tree -> Z_as_Int.t -> __ -> __ -> 'a4) -> ('a1 tree -> 'a2
              tree -> 'a1 tree -> key -> 'a1 -> 'a1 tree -> Z_as_Int.t -> __
              -> 'a2 tree -> key -> 'a2 -> 'a2 tree -> Z_as_Int.t -> __ ->
              'a2 tree -> 'a2 option -> 'a2 tree -> __ -> 'a3 -> __ -> 'a3
              tree -> ('a1, 'a2, 'a3) coq_R_map2_opt -> 'a4 -> 'a3 tree ->
              ('a1, 'a2, 'a3) coq_R_map2_opt -> 'a4 -> 'a4) -> ('a1 tree ->
              'a2 tree -> 'a1 tree -> key -> 'a1 -> 'a1 tree -> Z_as_Int.t ->
              __ -> 'a2 tree -> key -> 'a2 -> 'a2 tree -> Z_as_Int.t -> __ ->
              'a2 tree -> 'a2 option -> 'a2 tree -> __ -> __ -> 'a3 tree ->
              ('a1, 'a2, 'a3) coq_R_map2_opt -> 'a4 -> 'a3 tree -> ('a1, 'a2,
              'a3) coq_R_map2_opt -> 'a4 -> 'a4) -> 'a1 tree -> 'a2 tree ->
              'a3 tree -> ('a1, 'a2, 'a3) coq_R_map2_opt -> 'a4 **)

          let rec coq_R_map2_opt_rect f mapl mapr f0 f1 f2 f3 _ _ _ = function
          | R_map2_opt_0 (m1, m2) -> f0 m1 m2 __
          | R_map2_opt_1 (m1, m2, l1, x1, d1, r1, _x) ->
            f1 m1 m2 l1 x1 d1 r1 _x __ __
          | R_map2_opt_2 (m1, m2, l1, x1, d1, r1, _x, _x0, _x1, _x2, _x3,
                          _x4, l2', o2, r2', e, _res0, r0, _res, r2) ->
            f2 m1 m2 l1 x1 d1 r1 _x __ _x0 _x1 _x2 _x3 _x4 __ l2' o2 r2' __ e
              __ _res0 r0
              (coq_R_map2_opt_rect f mapl mapr f0 f1 f2 f3 l1 l2' _res0 r0)
              _res r2
              (coq_R_map2_opt_rect f mapl mapr f0 f1 f2 f3 r1 r2' _res r2)
          | R_map2_opt_3 (m1, m2, l1, x1, d1, r1, _x, _x0, _x1, _x2, _x3,
                          _x4, l2', o2, r2', _res0, r0, _res, r2) ->
            f3 m1 m2 l1 x1 d1 r1 _x __ _x0 _x1 _x2 _x3 _x4 __ l2' o2 r2' __
              __ _res0 r0
              (coq_R_map2_opt_rect f mapl mapr f0 f1 f2 f3 l1 l2' _res0 r0)
              _res r2
              (coq_R_map2_opt_rect f mapl mapr f0 f1 f2 f3 r1 r2' _res r2)

          (** val coq_R_map2_opt_rec :
              (key -> 'a1 -> 'a2 option -> 'a3 option) -> ('a1 tree -> 'a3
              tree) -> ('a2 tree -> 'a3 tree) -> ('a1 tree -> 'a2 tree -> __
              -> 'a4) -> ('a1 tree -> 'a2 tree -> 'a1 tree -> key -> 'a1 ->
              'a1 tree -> Z_as_Int.t -> __ -> __ -> 'a4) -> ('a1 tree -> 'a2
              tree -> 'a1 tree -> key -> 'a1 -> 'a1 tree -> Z_as_Int.t -> __
              -> 'a2 tree -> key -> 'a2 -> 'a2 tree -> Z_as_Int.t -> __ ->
              'a2 tree -> 'a2 option -> 'a2 tree -> __ -> 'a3 -> __ -> 'a3
              tree -> ('a1, 'a2, 'a3) coq_R_map2_opt -> 'a4 -> 'a3 tree ->
              ('a1, 'a2, 'a3) coq_R_map2_opt -> 'a4 -> 'a4) -> ('a1 tree ->
              'a2 tree -> 'a1 tree -> key -> 'a1 -> 'a1 tree -> Z_as_Int.t ->
              __ -> 'a2 tree -> key -> 'a2 -> 'a2 tree -> Z_as_Int.t -> __ ->
              'a2 tree -> 'a2 option -> 'a2 tree -> __ -> __ -> 'a3 tree ->
              ('a1, 'a2, 'a3) coq_R_map2_opt -> 'a4 -> 'a3 tree -> ('a1, 'a2,
              'a3) coq_R_map2_opt -> 'a4 -> 'a4) -> 'a1 tree -> 'a2 tree ->
              'a3 tree -> ('a1, 'a2, 'a3) coq_R_map2_opt -> 'a4 **)

          let rec coq_R_map2_opt_rec f mapl mapr f0 f1 f2 f3 _ _ _ = function
          | R_map2_opt_0 (m1, m2) -> f0 m1 m2 __
          | R_map2_opt_1 (m1, m2, l1, x1, d1, r1, _x) ->
            f1 m1 m2 l1 x1 d1 r1 _x __ __
          | R_map2_opt_2 (m1, m2, l1, x1, d1, r1, _x, _x0, _x1, _x2, _x3,
                          _x4, l2', o2, r2', e, _res0, r0, _res, r2) ->
            f2 m1 m2 l1 x1 d1 r1 _x __ _x0 _x1 _x2 _x3 _x4 __ l2' o2 r2' __ e
              __ _res0 r0
              (coq_R_map2_opt_rec f mapl mapr f0 f1 f2 f3 l1 l2' _res0 r0)
              _res r2
              (coq_R_map2_opt_rec f mapl mapr f0 f1 f2 f3 r1 r2' _res r2)
          | R_map2_opt_3 (m1, m2, l1, x1, d1, r1, _x, _x0, _x1, _x2, _x3,
                          _x4, l2', o2, r2', _res0, r0, _res, r2) ->
            f3 m1 m2 l1 x1 d1 r1 _x __ _x0 _x1 _x2 _x3 _x4 __ l2' o2 r2' __
              __ _res0 r0
              (coq_R_map2_opt_rec f mapl mapr f0 f1 f2 f3 l1 l2' _res0 r0)
              _res r2
              (coq_R_map2_opt_rec f mapl mapr f0 f1 f2 f3 r1 r2' _res r2)

          (** val fold' :
              (key -> 'a1 -> 'a2 -> 'a2) -> 'a1 tree -> 'a2 -> 'a2 **)

          let fold' f s =
            L.fold f (elements s)

          (** val flatten_e : 'a1 enumeration -> (key * 'a1) list **)

          let rec flatten_e = function
          | End -> []
          | More (x, e0, t0, r) ->
            (x, e0) :: (app (elements t0) (flatten_e r))
         end
       end

      type 'elt bst =
        'elt Raw.tree
        (* singleton inductive, whose constructor was Bst *)

      (** val this : 'a1 bst -> 'a1 Raw.tree **)

      let this b =
        b

      type 'elt t = 'elt bst

      type key = Equality.sort

      (** val empty : 'a1 t **)

      let empty =
        Raw.empty

      (** val is_empty : 'a1 t -> bool **)

      let is_empty m =
        Raw.is_empty (this m)

      (** val add : key -> 'a1 -> 'a1 t -> 'a1 t **)

      let add x e m =
        Raw.add x e (this m)

      (** val remove : key -> 'a1 t -> 'a1 t **)

      let remove x m =
        Raw.remove x (this m)

      (** val mem : key -> 'a1 t -> bool **)

      let mem x m =
        Raw.mem x (this m)

      (** val find : key -> 'a1 t -> 'a1 option **)

      let find x m =
        Raw.find x (this m)

      (** val map : ('a1 -> 'a2) -> 'a1 t -> 'a2 t **)

      let map f m =
        Raw.map f (this m)

      (** val mapi : (key -> 'a1 -> 'a2) -> 'a1 t -> 'a2 t **)

      let mapi f m =
        Raw.mapi f (this m)

      (** val map2 :
          ('a1 option -> 'a2 option -> 'a3 option) -> 'a1 t -> 'a2 t -> 'a3 t **)

      let map2 f m m' =
        Raw.map2 f (this m) (this m')

      (** val elements : 'a1 t -> (key * 'a1) list **)

      let elements m =
        Raw.elements (this m)

      (** val cardinal : 'a1 t -> int **)

      let cardinal m =
        Raw.cardinal (this m)

      (** val fold : (key -> 'a1 -> 'a2 -> 'a2) -> 'a1 t -> 'a2 -> 'a2 **)

      let fold f m i =
        Raw.fold f (this m) i

      (** val equal : ('a1 -> 'a1 -> bool) -> 'a1 t -> 'a1 t -> bool **)

      let equal cmp m m' =
        Raw.equal cmp (this m) (this m')
     end

    module Lemmas = FMapLemmas(M)

    module SE =
     struct
      (** val coq_T : Equality.coq_type **)

      let coq_T =
        V.coq_T

      type t = Equality.sort

      (** val ltn : t -> t -> bool **)

      let ltn =
        V.ltn

      (** val compare : t -> t -> t OrderedType.coq_Compare **)

      let compare =
        V.compare

      (** val eq_dec : t -> t -> bool **)

      let eq_dec =
        V.eq_dec
     end

    module E =
     struct
      type t = Equality.sort

      (** val compare :
          Equality.sort -> Equality.sort -> Equality.sort
          OrderedType.coq_Compare **)

      let compare =
        V.compare

      (** val eq_dec : Equality.sort -> Equality.sort -> bool **)

      let eq_dec =
        V.eq_dec
     end

    module Raw = M.Raw

    type 'elt bst =
      'elt Raw.tree
      (* singleton inductive, whose constructor was Bst *)

    (** val this : 'a1 bst -> 'a1 Raw.tree **)

    let this b =
      b

    type 'elt t = 'elt bst

    type key = Equality.sort

    (** val empty : 'a1 t **)

    let empty =
      Raw.empty

    (** val is_empty : 'a1 t -> bool **)

    let is_empty m =
      Raw.is_empty (this m)

    (** val add : key -> 'a1 -> 'a1 t -> 'a1 t **)

    let add x e m =
      Raw.add x e (this m)

    (** val remove : key -> 'a1 t -> 'a1 t **)

    let remove x m =
      Raw.remove x (this m)

    (** val mem : key -> 'a1 t -> bool **)

    let mem x m =
      Raw.mem x (this m)

    (** val find : key -> 'a1 t -> 'a1 option **)

    let find x m =
      Raw.find x (this m)

    (** val map : ('a1 -> 'a2) -> 'a1 t -> 'a2 t **)

    let map f m =
      Raw.map f (this m)

    (** val mapi : (key -> 'a1 -> 'a2) -> 'a1 t -> 'a2 t **)

    let mapi f m =
      Raw.mapi f (this m)

    (** val map2 :
        ('a1 option -> 'a2 option -> 'a3 option) -> 'a1 t -> 'a2 t -> 'a3 t **)

    let map2 f m m' =
      Raw.map2 f (this m) (this m')

    (** val elements : 'a1 t -> (key * 'a1) list **)

    let elements m =
      Raw.elements (this m)

    (** val cardinal : 'a1 t -> int **)

    let cardinal m =
      Raw.cardinal (this m)

    (** val fold : (key -> 'a1 -> 'a2 -> 'a2) -> 'a1 t -> 'a2 -> 'a2 **)

    let fold f m i =
      Raw.fold f (this m) i

    (** val equal : ('a1 -> 'a1 -> bool) -> 'a1 t -> 'a1 t -> bool **)

    let equal cmp m m' =
      Raw.equal cmp (this m) (this m')
   end

  type t = bits M.t

  (** val empty : t **)

  let empty =
    M.empty

  (** val acc : Equality.sort -> t -> bits **)

  let acc x s =
    match M.find x s with
    | Some v -> v
    | None -> BitsValueType.default

  (** val upd : Equality.sort -> bits -> t -> bits M.t **)

  let upd =
    M.add

  (** val upd2 : Equality.sort -> bits -> Equality.sort -> bits -> t -> t **)

  let upd2 x1 v1 x2 v2 s =
    upd x2 v2 (upd x1 v1 s)

  module Lemmas = TypEnv.TypEnvLemmas(TE)
 end

module Store = MakeBitsStore(VarOrder)(TypEnv.TE)

module SSAStore = MakeBitsStore(SSAVarOrder)(TypEnv.SSATE)
