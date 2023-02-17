module Steel.C.Model.Ref
open FStar.FunctionalExtensionality
open Steel.C.Model.PCM
open Steel.C.Model.Connection
include Steel.C.Model.Ref.Base

#push-options "--print_universes"

open Steel.Effect

module A = Steel.Effect.Atomic

(** Allocate a reference containing value x. *)
val ref_alloc
  (#a:Type0) (p: pcm a) (x: a)
: Steel (ref a p)
    emp
    (fun r -> r `pts_to` x)
    (requires fun _ -> p_refine p x)
    (ensures fun _ r _ -> freeable r)

(** Free a "base" (freeable) reference containing a "whole" (p_refine) value x. *)
val ref_free
  (#a #b:Type0) (#p: pcm b) (#x: Ghost.erased b) (r: ref a p)
: Steel unit
    (r `pts_to` x)
    (fun _ -> emp)
    (requires fun _ -> p_refine p x /\ freeable r)
    (ensures fun _ _ _ -> True)


(** Take a pointer to a "substructure" of a reference. *)
val gfocus (#inames: _) (#p: pcm 'b) (r: ref 'a p)
  (#q: pcm 'c)
  (l: connection p q) (s: Ghost.erased 'b) (x: Ghost.erased 'c)
: A.SteelGhost unit inames
    (r `pts_to` s)
    (fun _ -> ref_focus r l `pts_to` x)
    (fun _ -> Ghost.reveal s == l.conn_small_to_large.morph x)
    (fun _ _ _ -> True)

val focus (#opened: _) (#p: pcm 'b) (r: ref 'a p)
  (#q: pcm 'c)
  (l: connection p q) (s: Ghost.erased 'b) (x: Ghost.erased 'c)
: A.SteelAtomicBase (ref 'a q)
    false opened A.Unobservable
    (r `pts_to` s)
    (fun r' -> r' `pts_to` x)
    (fun _ -> Ghost.reveal s == l.conn_small_to_large.morph x)
    (fun _ r' _ -> r' == ref_focus r l)

module M = Steel.Memory

(** Inverse of focus. *)
val unfocus (#opened:M.inames)
  (#p: pcm 'b)
  (#q: pcm 'c)
  (r: ref 'a q) (r': ref 'a p)
  (l: connection p q) (x: Ghost.erased 'c)
: A.SteelGhost unit opened
    (r `pts_to` x)
    (fun _ -> r' `pts_to` l.conn_small_to_large.morph x)
    (requires fun _ -> r == ref_focus r' l)
    (ensures fun _ _ _ -> True)

(** Split the permissions on a reference into two halves. *)
val split (#inames: _) (#a:Type) (#b:Type) (#p: pcm b) (r: ref a p) (xy x y: Ghost.erased b)
: A.SteelGhost unit inames
    (r `pts_to` xy)
    (fun _ -> (r `pts_to` x) `star` (r `pts_to` y))
    (fun _ -> composable p x y /\ xy == Ghost.hide (op p x y))
    (fun _ _ _ -> True)

(** Inverse of split. *)
val gather (#inames: _) (#a:Type) (#b:Type) (#p: pcm b) (r: ref a p) (x y: Ghost.erased b)
: A.SteelGhostT (_:unit{composable p x y}) inames
    ((r `pts_to` x) `star` (r `pts_to` y))
    (fun _ -> r `pts_to` op p x y)

(** Read a PCM carrier value. *)
val ref_read
  (#a:Type) (#b:Type) (#p: pcm b) (#x: Ghost.erased b) (r: ref a p)
: Steel b
    (r `pts_to` x)
    (fun _ -> r `pts_to` x)
    (requires fun _ -> True)
    (ensures fun _ x' _ -> compatible p x x')

(** Write a PCM carrier value. *)
val ref_upd
  (#a:Type) (#b:Type) (#p: pcm b)
  (r: ref a p) (x: Ghost.erased b { ~ (Ghost.reveal x == one p) }) (y: Ghost.erased b) (f: frame_preserving_upd p x y)
: SteelT unit (r `pts_to` x) (fun _ -> r `pts_to` y)

(** PCM carrier values are cumbersome to work with directly. To
    abstract over them, we define "view"s, which are essentially
    lossless partial functions from PCM carrier values to "view
    types".  *)
noeq
type sel_view
  (#carrier: Type u#a)
  (p: pcm carrier)
  (view: Type u#b)
  (can_view_unit:bool)
= {
  (** When is a PCM carrier value viewable? *)
  to_view_prop: (carrier -> Tot prop);
  to_view: (refine carrier to_view_prop -> Tot view);
  (** Construct a PCM carrier value from a view (used for writes) *)
  to_carrier: (view -> Tot (refine carrier to_view_prop));
  (** If can_view_unit is false, then the unit of the PCM must be unviewable.
      If can_view_unit is true, all bets are off.
      This was originally used to allow viewing empty structs (which
      would have can_view_unit := true).  Empty structs aren't useful
      in C programming, but they can temporarily arise in our model
      after one has taken pointers to every field of a nonempty
      struct.
      We eventually found a different way of coping with this
      situation (see Steel.C.StructLiteral for details), so we in fact use (can_view_unit := false) everywhere
      and we could get rid of can_view_unit entirely. *)
  to_carrier_not_one:
    squash (~ can_view_unit ==> ~ (exists x. to_carrier x == one p) /\ ~ (to_view_prop (one p)));
  (** The PCM carrier value corresponding to a view must be stable under composition with surrounding frames. *)
  to_view_frame:
    (x: view) ->
    (frame: carrier) ->
    Lemma
    (requires (composable p (to_carrier x) frame))
    (ensures (to_view_prop (op p (to_carrier x) frame) /\ to_view (op p (to_carrier x) frame) == x));
}

(** Every sel_view gives rise to a selector, which we can use to hide even the view-type values. *)

let weaken_view (#p: pcm 'a) (v: sel_view p 'b false): sel_view p 'b true = {
  to_view_prop = v.to_view_prop;
  to_view = v.to_view;
  to_carrier = v.to_carrier;
  to_carrier_not_one = ();
  to_view_frame = v.to_view_frame;
}

let g_is_inverse_of (#a #b: Type) (g: (b -> GTot a)) (f: (a -> GTot b)) : Tot prop =
  (forall x . {:pattern (g (f x))} g (f x) == x)

let sel_view_inv
  (#carrier: Type u#a)
  (#p: pcm carrier)
  (#view: Type u#b)
  (#can_view_unit: bool)
  (vw: sel_view p view can_view_unit)
: Lemma
  (vw.to_view `g_is_inverse_of` vw.to_carrier)
  [SMTPat (has_type vw (sel_view p view can_view_unit))]
= let aux
    (x: view)
  : Lemma
    (vw.to_view (vw.to_carrier x) == x)
    [SMTPat (vw.to_view (vw.to_carrier x))]
  = is_unit p (vw.to_carrier x);
    vw.to_view_frame x (one p)
  in
  ()

val pts_to_view_sl
  (#a: Type u#0) (#b: Type u#b) (#p: pcm b)
  (r: ref a p)
  (#c: Type u#c)
  (#can_view_unit: bool)
  (vw: sel_view p c can_view_unit)
: Tot (M.slprop u#1)

val pts_to_view_sel
  (#a: Type u#0) (#b: Type u#b) (#p: pcm b)
  (r: ref a p)
  (#c: Type0)
  (#can_view_unit: bool)
  (vw: sel_view p c can_view_unit)
: Tot (selector c (pts_to_view_sl r vw))

[@@__steel_reduce__]
let pts_to_view'
  (#a: Type u#0) (#b: Type u#b) (#p: pcm b)
  (r: ref a p)
  (#c: Type0)
  (#can_view_unit: bool)
  (vw: sel_view p c can_view_unit)
: Tot vprop'
= {
  hp = pts_to_view_sl r vw;
  t = c;
  sel = pts_to_view_sel r vw;
}

[@@__steel_reduce__]
let pts_to_view 
  (#a: Type u#0) (#b: Type u#b) (#p: pcm b)
  (r: ref a p)
  (#c: Type0)
  (#can_view_unit: bool)
  (vw: sel_view p c can_view_unit)
  //(#a: Type u#0) (#[@@@smt_fallback] b: Type u#b) (#[@@@smt_fallback] p: pcm b)
  //(r: ref a p)
  //(#[@@@smt_fallback] c: Type0)
  //(#can_view_unit: bool)
  //([@@@smt_fallback] vw: sel_view p c can_view_unit)
: Tot vprop
= VUnit (pts_to_view' r vw)

val pts_to_view_intro
  (#invs: _)
  (#a: Type u#0) (#b: Type u#b) (#p: pcm b)
  (r: ref a p)
  (x: Ghost.erased b)
  (#c: Type0)
  (#can_view_unit: bool)
  (vw: sel_view p c can_view_unit)
  (y: Ghost.erased c) // necessary because to_view may erase information from x
: A.SteelGhost unit invs
    (pts_to r x)
    (fun _ -> pts_to_view r vw)
    (fun _ -> vw.to_carrier y == Ghost.reveal x)
    (fun _ _ h' ->
      h' (pts_to_view r vw) == Ghost.reveal y
    )

val pts_to_view_elim
  (#invs: _)
  (#a: Type u#0) (#b: Type u#b) (#p: pcm b)
  (r: ref a p)
  (#c: Type0)
  (#can_view_unit: bool)
  (vw: sel_view p c can_view_unit)
: A.SteelGhost (Ghost.erased b) invs
    (pts_to_view r vw)
    (fun res -> pts_to r res)
    (fun _ -> True)
    (fun h res _ ->
      Ghost.reveal res == vw.to_carrier (h (pts_to_view r vw)) /\
      vw.to_view_prop res /\
      True //~ (Ghost.reveal res == one p)
    )

val ref_read_sel
  (#a: Type u#0) (#b: Type u#b) (#p: pcm b)
  (r: ref a p)
  (#c: Type0)
  (#can_view_unit: bool)
  (vw: sel_view p c can_view_unit)
: Steel c
  (pts_to_view r vw)
  (fun _ -> pts_to_view r vw)
  (requires (fun _ -> True))
  (ensures (fun h res h' ->
    res == h (pts_to_view r vw) /\
    res == h' (pts_to_view r vw)
  ))

(* write cannot be defined generically because of p_refine *)

/// Pointers (and the null pointer)

val pts_to_view_or_null_sl
  (#a: Type u#0) (#b: Type u#b) (#p: pcm b)
  (r: ptr a p)
  (#c: Type u#0)
  (#can_view_unit: bool)
  (vw: sel_view p c can_view_unit)
: Tot (M.slprop u#1)

val pts_to_view_or_null_sel
  (#a: Type u#0) (#b: Type u#b) (#p: pcm b)
  (r: ptr a p)
  (#c: Type0)
  (#can_view_unit: bool)
  (vw: sel_view p c can_view_unit)
: GTot (selector (option c) (pts_to_view_or_null_sl r vw))

[@@__steel_reduce__]
let pts_to_view_or_null'
  (#a: Type u#0) (#b: Type u#b) (#p: pcm b)
  (r: ptr a p)
  (#c: Type0)
  (#can_view_unit: bool)
  (vw: sel_view p c can_view_unit)
: GTot vprop'
= {
  hp = pts_to_view_or_null_sl r vw;
  t = option c;
  sel = pts_to_view_or_null_sel r vw;
}

[@@__steel_reduce__]
let pts_to_view_or_null
  (#a: Type u#0) (#b: Type u#b) (#p: pcm b)
  (r: ptr a p)
  (#c: Type0)
  (#can_view_unit: bool)
  (vw: sel_view p c can_view_unit)
: Tot vprop
= VUnit (pts_to_view_or_null' r vw)

val is_null
  (#a: Type u#0) (#b: Type u#b) (#p: pcm b)
  (#opened: _)
  (r: ptr a p)
  (#c: Type0)
  (#can_view_unit: bool)
  (vw: sel_view p c can_view_unit)
: A.SteelAtomicBase bool false opened A.Unobservable
    (pts_to_view_or_null r vw)
    (fun _ -> pts_to_view_or_null r vw)
    (requires (fun _ -> True))
    (ensures (fun h res h' ->
      let s = h (pts_to_view_or_null r vw) in
      h' (pts_to_view_or_null r vw) == s /\
      res == ptr_is_null r /\
      res == (None? s)
    ))

val intro_pts_to_view_or_null_null
  (#inames: _)
  (a: Type) (#b: Type) (#p: pcm b)
  (#c: Type0)
  (#can_view_unit: bool)
  (vw: sel_view p c can_view_unit)
: A.SteelGhost unit inames
    emp
    (fun _ -> pts_to_view_or_null (null a p) vw)
    (requires (fun _ -> True))
    (ensures (fun _ _ h' -> h' (pts_to_view_or_null (null a p) vw) == None))

val elim_pts_to_view_or_null_null
  (#inames: _)
  (a: Type) (#b: Type) (#p: pcm b)
  (#c: Type0)
  (#can_view_unit: bool)
  (vw: sel_view p c can_view_unit)
: A.SteelGhostT unit inames
    (pts_to_view_or_null (null a p) vw)
    (fun _ -> emp)

val intro_pts_to_view_or_null_not_null
  (#inames: _)
  (#a: Type) (#b: Type) (#p: pcm b)
  (r: ref a p)
  (#c: Type0)
  (#can_view_unit: bool)
  (vw: sel_view p c can_view_unit)
: A.SteelGhost unit inames
    (pts_to_view r vw)
    (fun _ -> pts_to_view_or_null r vw)
    (requires (fun _ -> True))
    (ensures (fun h _ h' -> h' (pts_to_view_or_null r vw) == Some (h (pts_to_view r vw))))

val elim_pts_to_view_or_null_not_null
  (#inames: _)
  (#a: Type) (#b: Type) (#p: pcm b)
  (r: ref a p)
  (#c: Type0)
  (#can_view_unit: bool)
  (vw: sel_view p c can_view_unit)
: A.SteelGhost unit inames
    (pts_to_view_or_null r vw)
    (fun _ -> pts_to_view r vw)
    (requires (fun _ -> True))
    (ensures (fun h _ h' -> h (pts_to_view_or_null r vw) == Some (h' (pts_to_view r vw))))
