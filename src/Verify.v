
From Coq Require Import List ZArith.
From mathcomp Require Import ssreflect ssrbool ssrnat eqtype seq ssrfun.
From ssrlib Require Import Var Types SsrOrder Seqs Tactics.
From Cryptoline Require Import Options DSL SSA ZSSA SSA2QFBV SSA2ZSSA QFBV2CNF Poly.
From Coq Require Import Ring_polynom.

Set Implicit Arguments.
Unset Strict Implicit.
Import Prenex Implicits.


Section Verification.

  Import CNF.

  (* This is the external SAT solver.
     The correctness is guaranteed by the external solver. *)
  Parameter ext_all_unsat : seq cnf -> bool.

  Axiom all_unsat_sound :
    forall css : seq cnf,
      ext_all_unsat css ->
      forall cs, cs \in css -> ~ sat cs.

  Axiom all_unsat_complete :
    forall css : seq cnf,
      (forall cs, cs \in css -> ~ sat cs) ->
      ext_all_unsat css.

  Definition verify_rspec_algsnd (s : SSA.spec) : bool :=
    let fE := SSA.program_succ_typenv (SSA.sprog s) (SSA.sinputs s) in
    let es := bb_range_algsnd_la_simplified_filtered s in
    let '(_, _, _, cnfs) := bb_hbexps_cache fE (map QFBVHash.hash_bexp es) in
    ext_all_unsat cnfs.

  Lemma verify_rspec_algsnd_sound (s : SSA.spec) :
    well_formed_ssa_spec s ->
    verify_rspec_algsnd s ->
    SSA.valid_rspec (SSA.rspec_of_spec s) /\ ssa_spec_algsnd s.
  Proof.
    move=> Hwf Hv. apply: (bb_range_algsnd_la_simplified_filtered_sound Hwf).
    move=> m c g cnfs cnf Hbb Hin. rewrite /verify_rspec_algsnd in Hv.
    rewrite Hbb in Hv. move: (all_unsat_sound Hv) => Hsat.
    move: (Hsat cnf Hin) => {Hsat} Hsat.
    move=> Hsat'; apply: Hsat. exact: Hsat'.
  Qed.

  Lemma verify_rspec_algsnd_complete (s : SSA.spec) :
    well_formed_ssa_spec s ->
    SSA.valid_rspec (SSA.rspec_of_spec s) -> ssa_spec_algsnd s ->
    verify_rspec_algsnd s.
  Proof.
    move=> Hwf Hrange Hsafe. rewrite /verify_rspec_algsnd.
    dcase (bb_hbexps_cache (SSA.program_succ_typenv (SSA.sprog s) (SSA.sinputs s))
                           (map QFBVHash.hash_bexp
                                (bb_range_algsnd_la_simplified_filtered s))) =>
    [[[[m c] g] cnfs] Hbb].
    apply: all_unsat_complete.
    move: (bb_range_algsnd_la_simplified_filtered_complete Hwf Hrange Hsafe) => Hv.
    move=> cs Hin. apply: (Hv _ _ _ _ _ Hbb). assumption.
  Qed.


  (** Solve an ideal membership problems by external computer algebra systems.
      An ideal membership problem is given as a tuple (ps, m, q). The problem
      is to check if q is in the ideal of m::ps, i.e., there are cs and c such
      that q = cs * ps + c * m. ext_solve_imp returns such (cs, c). *)
  Parameter ext_solve_imp :
    seq (PExpr Z) -> PExpr Z -> PExpr Z -> seq (PExpr Z) * (PExpr Z).

  (** Verify an atomic root entailment problem by reducing the problem to an
      ideal membership problem, solving the ideal membership problem by an
      external computer algebra system, and validating the answer from the
      computer algebra system. *)
  Definition verify_arep (ps : arep) : bool :=
    let '(_, _, ps, m, q) := imp_of_arep ps in
    let (cs, c) := ext_solve_imp ps q m in
    validate_imp_answer_tr ps m q cs c.

  Definition verify_areps (pss : seq arep) : bool := all verify_arep pss.

  (** Verify a root entailment problem by reducing the problem to atomic
      root entailment problems and then verifying the atomic problems
      through verify_areps. *)
  Definition verify_rep (o : options) (zs : ZSSA.rep) : bool :=
    if rewrite_assignments o
    then verify_areps (areps_of_rep_simplified o zs)
    else verify_areps (areps_of_rep zs).

  Lemma verify_arep_sound ps : verify_arep ps -> valid_arep ps.
  Proof.
    rewrite /verify_arep. dcase (imp_of_arep ps) => [[[[[g t] zps] zm] zq] Hzp].
    dcase (ext_solve_imp zps zq zm) => [[cs c] Hco]. move=> Hch.
    exact: (validated_imp_tr_valid_arep Hzp Hch).
  Qed.

  Lemma verify_areps_in ps pss :
    verify_areps pss -> ps \in pss -> valid_arep ps.
  Proof.
    elim: pss => [| hd tl IH] //=. move/andP=> [Hhd Htl] Hin.
    rewrite in_cons in Hin. case/orP: Hin => Hin.
    - rewrite (eqP Hin). exact: (verify_arep_sound Hhd).
    - exact: (IH Htl Hin).
  Qed.

  Lemma verify_rep_sound o (zs : ZSSA.rep) :
    verify_rep o zs -> ZSSA.valid_rep zs.
  Proof.
    rewrite /verify_rep. case: (rewrite_assignments o) => Hv.
    - apply: (@areps_of_rep_simplified_sound o) => ps Hin.
      exact: (verify_areps_in Hv Hin).
    - apply: areps_of_rep_sound => ps Hin.
      exact: (verify_areps_in Hv Hin).
  Qed.


  (* Solve a sequence of ideal membership problems by external computer
     algebra systems. An ideal membership problem is given as a tuple
     (ps, m, q). The problem is to check if q is in the ideal of m::ps,
     i.e., there are cs and c such that q = cs * ps + c * m.
     ext_solve_imp_list returns a sequence of (cs, c). *)
  Parameter ext_solve_imp_list :
    seq (seq (PExpr Z) * PExpr Z * PExpr Z) -> seq (seq (PExpr Z) * (PExpr Z)).

  Axiom ext_solve_imp_list_cons :
    forall ps m q tl,
      ext_solve_imp_list ((ps, m, q)::tl) =
      (ext_solve_imp ps m q)::(ext_solve_imp_list tl).

  Definition polys_of_areps (pss : seq arep) :
    seq (seq (PExpr Z) * PExpr Z * PExpr Z) :=
    let f ps :=
        let '(_, _, ps, m, q) := imp_of_arep ps in
        (ps, q, m) in
    map f pss.

  Fixpoint validate_imp_answer_tr_list polys coefs : bool :=
    match polys, coefs with
    | [::], [::] => true
    | ((ps, q, m)::tlp), ((cs, c)::tlc) => if validate_imp_answer_tr ps m q cs c
                                           then validate_imp_answer_tr_list tlp tlc
                                           else false
    | _, _ => false
    end.

  Definition verify_areps_list (pss : seq arep) : bool :=
    let poly_list := polys_of_areps pss in
    let coef_list := ext_solve_imp_list poly_list in
    if size poly_list == size coef_list
    then validate_imp_answer_tr_list poly_list coef_list
    else false.

  Definition verify_rep_list (o : options) (zs : ZSSA.rep) : bool :=
    if rewrite_assignments o
    then verify_areps_list (areps_of_rep_simplified o zs)
    else verify_areps_list (areps_of_rep zs).

  Lemma verify_areps_list_in psp psps :
    verify_areps_list psps -> psp \in psps -> valid_arep psp.
  Proof.
    elim: psps => [| hd tl IH] //=. rewrite /verify_areps_list.
    case Hs: (size (polys_of_areps (hd :: tl)) ==
              size (ext_solve_imp_list (polys_of_areps (hd :: tl)))) => //=.
    dcase (imp_of_arep hd) => [[[[[g t] ps] m] q] Hhd] /=.
    rewrite Hhd in Hs. rewrite ext_solve_imp_list_cons /= in Hs.
    rewrite eqSS in Hs. rewrite ext_solve_imp_list_cons.
    dcase (ext_solve_imp ps q m) => [[cs c] Hcs].
    case Hchk_hd: (validate_imp_answer_tr ps m q cs c) => //=.
    move=> Hchk_tl Hin. rewrite in_cons in Hin. case/orP: Hin => Hin.
    - rewrite (eqP Hin). exact: (validated_imp_tr_valid_arep Hhd Hchk_hd).
    - apply: (IH _ Hin). rewrite /verify_areps_list. rewrite Hs. exact: Hchk_tl.
  Qed.

  Lemma verify_rep_list_sound o (zs : ZSSA.rep) :
    verify_rep_list o zs -> ZSSA.valid_rep zs.
  Proof.
    rewrite /verify_rep_list. case: (rewrite_assignments o) => Hv.
    - apply: (@areps_of_rep_simplified_sound o) => ps Hin.
      exact: (verify_areps_list_in Hv Hin).
    - apply: areps_of_rep_sound => ps Hin.
      exact: (verify_areps_list_in Hv Hin).
  Qed.

  Definition verify_espec (o : options) (s : SSA.spec) :=
    if compute_coefficients_one_by_one o
    then (verify_rep o (algred_espec o (new_svar_spec s) (SSA.espec_of_spec s)))
    else (verify_rep_list o (algred_espec o (new_svar_spec s) (SSA.espec_of_spec s))).


  (* Verify specifications *)

  Definition verify_ssa (o : options) (s : SSA.spec) :=
    (verify_rspec_algsnd s) && (verify_espec o s).

  Definition verify_dsl (o : options) (s : DSL.spec) :=
    verify_ssa o (ssa_spec s).

  Theorem verify_ssa_sound (o : options) (s : SSA.spec) :
    well_formed_ssa_spec s ->
    verify_ssa o s ->
    SSA.valid_spec s.
  Proof.
    rewrite /verify_ssa /verify_espec=> Hwf /andP [Hvrs Hvz].
    move: (verify_rspec_algsnd_sound Hwf Hvrs) => [Hvr Hvs].
    apply: (algred_spec_sound (o:=o) Hwf Hvs Hvr).
    case Hc: (compute_coefficients_one_by_one o) Hvz => Hvz.
    - exact: (verify_rep_sound Hvz).
    - exact: (verify_rep_list_sound Hvz).
  Qed.

  Theorem verify_dsl_sound (o : options) (s : DSL.spec) :
    DSL.well_formed_spec s ->
    verify_dsl o s ->
    DSL.valid_spec s.
  Proof.
    rewrite /verify_dsl => Hwf Hv. apply: ssa_spec_sound.
    apply: (verify_ssa_sound _ Hv).
    exact: (ssa_spec_well_formed Hwf).
  Qed.


End Verification.
