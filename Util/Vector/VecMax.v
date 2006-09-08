(************************************************************************
CoLoR, a Coq library on rewriting and termination.
See the COPYRIGHTS and LICENSE files.

- Sebastien Hinderer, 2004-04-29
- Frederic Blanqui, 2005-02-02

greatest component of a vector of natural numbers
************************************************************************)

(* $Id: VecMax.v,v 1.1.1.1 2006-09-08 09:07:00 blanqui Exp $ *)

Set Implicit Arguments.

Require Export VecUtil.

Notation nats := (vector nat).

Require Export Max.

Fixpoint Vmax n (v : nats n) {struct v} : nat :=
  match v with
    | Vnil => O
    | Vcons a _ w => max a (Vmax w)
  end.

Lemma Vmax_head : forall n (v : nats (S n)), Vhead v <= Vmax v.

Proof.
intros n v. rewrite (VSn_eq v). simpl. auto with arith.
Qed.

Lemma Vmax_tail : forall n (v : nats (S n)), Vmax (Vtail v) <= Vmax v.

Proof.
intros n v. rewrite (VSn_eq v). simpl. auto with arith.
Qed.

Lemma Vmax_app : forall n1 (v1 : nats n1) p n2 (v2 : nats n2),
  p <= Vmax (Vapp v1 (Vcons p v2)).

Proof.
intros. elim v1.
 simpl. auto with arith.
 intros a n' w H. simpl.
 eapply le_trans. apply H.
 auto with arith.
Qed.

Lemma Vmax_forall : forall n (v : nats n) p,
  Vmax v <= p -> Vforall (fun n => n <= p) v.

Proof.
intros n v p. elim v.
 intro. simpl. auto.
 simpl. intros h n' t Hrec H. split.
  eapply le_trans. apply (le_max_l h (Vmax t)). assumption.
  apply (Hrec (le_trans (le_max_r h (Vmax t)) H)).
Qed.

Implicit Arguments Vmax_forall [n v p].
