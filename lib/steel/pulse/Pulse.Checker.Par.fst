module Pulse.Checker.Par

module T = FStar.Tactics.V2
module RT = FStar.Reflection.Typing

open FStar.List.Tot
open Pulse.Syntax
open Pulse.Typing
open Pulse.Checker.Pure
open Pulse.Checker.Common
open Pulse.Checker.Comp
open Pulse.Syntax.Printer

open FStar.Reflection.V2.TermEq

open FStar.Printf

module FV = Pulse.Typing.FV
module MT = Pulse.Typing.Metatheory

let print_term (t: term): T.Tac unit
  = T.print (term_to_string t)

let rec print_list_terms' (l: list term): T.Tac unit
= match l with
| [] -> T.print "]"
| t::q -> (T.print ", "; print_term t; print_list_terms' q)

let print_list_terms (l: list term): T.Tac unit
  = match l with
  | [] -> T.print "[]"
  | t::q -> (T.print "["; print_term t; print_list_terms' q)

let indent (level:string) = level ^ " "

let st_equiv_to_string (#g: env) #c1 #c2 (level: string) (eq: st_equiv g c1 c2)
  : T.Tac string
  = (*if comp_pre c1 = comp_pre c2 && comp_post c1 = comp_post c2
    then T.print "Trivial equivalence!"
    else T.print "Somehow non-trivial equivalence...";*)
    sprintf "st_equiv\n%s pre1: %s\n%s pre2: %s\n%s post1: %s\n%s post2: %s"
  //pre: (%s) (%s)) (post: (%s) (%s))"
  level
  (term_to_string (comp_pre c1))
  level
  (term_to_string (comp_pre c2))
  level
  (term_to_string (comp_post c1))
  level
  (term_to_string (comp_post c2))

let rec st_typing_to_string' (#g:env) (#t:st_term) (#c:comp) (level: string) (ty: st_typing g t c)
//let rec st_typing_to_string (ty: st_typing)
  : T.Tac string
  = match ty with
    | T_Abs g x q b u body c _ _ -> "T_Abs"
    | T_STApp g head _ q res arg _ _ -> "T_STapp"
    | T_Return g c use_eq u t e post x _ _ _ -> "T_Return"
    | T_Lift g e c1 c2 _ _ -> "T_Lift"
    | T_Bind g e1 e2 c1 c2 b x c ty1 _ ty2 _ ->
      sprintf "T_Bind \n (%s); \n (%s)"
      (st_typing_to_string' (indent level) ty1)
      (st_typing_to_string' (indent level) ty2)
    | T_TotBind g e1 e2 t1 c2 x _ ty' ->
      sprintf "T_TotBind (%s)"
      (st_typing_to_string' (indent level) ty')
    | T_Frame g e c frame _ ty' ->
      sprintf "T_Frame (frame=%s) (\n%s%s)"
      (term_to_string frame)
      level
      (st_typing_to_string' (indent level) ty')
    | T_Equiv g e c c' ty' equiv ->
      sprintf "T_Equiv (%s) (\n%s%s)"
      //(st_equiv_to_string level equiv)
      "..."
      level
      (st_typing_to_string' (indent level) ty')
    | T_Par g eL cL eR cR x _ _ ty1 ty2 -> "T_Par"
    | _ -> "Unsupported"
    // TODO: If

let st_typing_to_string (#g:env) (#t:st_term) (#c:comp) (ty: st_typing g t c)
  = st_typing_to_string' #g #t #c "" ty
//let st_typing_to_string #g #t #c (ty: st_typing g t c) = st_typing_to_string' "" ty

// Would need a stronger postcondition
// Like pre and post are equiv
let create_st_equiv (g: env) (c: comp_st) (c': comp_st)
: st_equiv g c c'
= let x = fresh g in
  assume ( ~(x `Set.mem` freevars (comp_post c)) /\
          ~(x `Set.mem` freevars (comp_post c')) );
  assume false;
  ST_VPropEquiv g c c' x (magic()) (magic()) (magic()) (magic()) (magic())

// This function replaces T_Frame with empty frames by T_Equiv
let rec replace_frame_emp_with_equiv #g #t #c (ty: st_typing g t c):
  Tot (st_typing g t c) (decreases ty)
  = match ty with
  | T_Frame g e c' frame tot_ty ty' -> 
  // c = add_frame c'
  if Tm_Emp? frame.t
    then let st_eq: st_equiv g c' c = create_st_equiv g c' c in
      T_Equiv g e c' c (replace_frame_emp_with_equiv ty') st_eq
    else ty
  | T_Equiv g e c c' ty' equiv ->
  T_Equiv g e c c' (replace_frame_emp_with_equiv ty') equiv
  | T_Bind g e1 e2 c1 c2 b x c ty1 tot1 ty2 tot2 ->
  T_Bind g e1 e2 c1 c2 b x c (replace_frame_emp_with_equiv ty1) tot1 (replace_frame_emp_with_equiv ty2) tot2
  | _ -> ty

// This function collapses two consecutive nested T_Equiv into one
let rec collapse_equiv #g #e #c (ty: st_typing g e c):
  //Tot (st_typing g e c) (decreases ty)
  T.Tac (st_typing g e c)
  = match ty with
  // Pattern: T_Equiv g e c' c ...
  | T_Equiv _ _ c' _ (T_Equiv _ _ c'' _ ty' eq') eq ->
  let st_eq: st_equiv g c'' c = create_st_equiv g c'' c in
  collapse_equiv (T_Equiv g e c'' c ty' st_eq)
  | T_Equiv _ _ c' _ ty' eq -> T_Equiv g e c' c (collapse_equiv ty') eq
  | T_Bind g e1 e2 c1 c2 b x c ty1 tot1 ty2 tot2 ->
  T_Bind g e1 e2 c1 c2 b x c (collapse_equiv ty1) tot1 (collapse_equiv ty2) tot2
  | _ -> ty

let rec collect_frames #g #e #c (ty: st_typing g e c):
  T.Tac (list term)
= match ty with
  | T_Frame g e c' frame tot_ty ty' -> [frame]
  | T_Equiv g e c c' ty' equiv -> collect_frames ty'
  | T_Bind g e1 e2 c1 c2 b x c ty1 tot1 ty2 tot2 -> collect_frames ty1 @ collect_frames ty2
  | _ -> T.fail "Unable to figure out frame at this leaf"
 
let simplify_st_typing #g #e #c (ty: st_typing g e c): T.Tac (st_typing g e c)
  = collapse_equiv (replace_frame_emp_with_equiv ty)

// Soundness: true ==> it is
// (false means we didn't find it, not that it's not there)
(*
let rec is_host_term_in_vprop (ft: host_term) (t: term)
  = match t.t with
  | Tm_FStar ht -> Reflection.term_eq ft ht
  | Tm_Star l r -> is_host_term_in_vprop ft l || is_host_term_in_vprop ft r
  | _ -> false
*)

//let fterm = t:host_term 

let deq (a: host_term) (b: host_term): (r:bool{r <==> (a == b)}) =
  (assume (faithful a); assume (faithful b); term_eq_dec a b)

let delta (a: host_term) (b: host_term): nat
  = if deq a b then 1 else 0

let rec countt (l: list host_term) (x: host_term): nat
  = match l with
  | [] -> 0
  | t::q -> delta t x + countt q x

// is destructive
let rec compute_intersection_aux (ft: host_term) (l: list host_term): list host_term & list host_term
  = match l with
  | [] -> ([], [])
  | t::q -> if deq ft t then ([t], q)
  else let (a, b) = compute_intersection_aux ft q in (a, t::b)
  // how to link
  // delta t x = countt l x - countt b x

// spec
let rec countt_compute_intersection (ft: host_term) (l: list host_term) (x: host_term):
  Lemma (let (a, b) = compute_intersection_aux ft l in (countt l x = countt a x + countt b x
  /\ length a <= 1 /\ length l = length a + length b
  /\ countt a x <= 1
  /\ (~(deq ft x) ==> countt a x = 0)
  /\ (countt a x = 1 <==> (deq ft x /\ countt l x >= 1))
  ))
= match l with
  | [] -> ()
  | t::q -> if deq ft t then ()
  else countt_compute_intersection ft q x

// Could probably be improved, in terms of performance
let rec compute_intersection (l1: list host_term) (l2: list host_term) =
  match l1 with
  | [] -> []
  | t::q -> let (a, b) = compute_intersection_aux t l2 // l2 = a @ b
  in a @ compute_intersection q b

let rec countt_append (l1: list host_term) (l2: list host_term) (x: host_term):
  Lemma (countt (l1 @ l2) x = countt l1 x + countt l2 x)
  = match l1 with
  | [] -> ()
  | t::q -> countt_append q l2 x

let rec compute_intersection_included (l1: list host_term) (l2: list host_term) (x: host_term):
  Lemma (let l = compute_intersection l1 l2 in
  countt l x = min (countt l1 x) (countt l2 x))
= match l1 with
  | [] -> ()
  | t::q -> let (a, b) = compute_intersection_aux t l2 in
   countt_compute_intersection t l2 x;
  calc (=) {
    countt (compute_intersection l1 l2) x;
    = { countt_append a (compute_intersection q b) x }
    countt a x + countt (compute_intersection q b) x;
    = { compute_intersection_included q b x }
    countt l2 x - countt b x + min (countt q x) (countt b x);
    = {}
    min (countt q x - countt b x + countt l2 x) (countt l2 x);
    = {}
    min (countt l1 x) (countt l2 x);
  }

// collects a subset of all host terms
// should collect typing proofs as well (using some trusted wrapper)
let rec term_to_list (t: term): list host_term
  = match t.t with
  | Tm_FStar ft -> [ft]
  | Tm_Star l r -> term_to_list l @ term_to_list r
  | _ -> []

(*
// basically a fold
let rec compute_intersection_list_aux (c: list host_term) (l: list (list host_term))
  = match l with
  | [] -> c
  | t::q -> compute_intersection_list_aux (compute_intersection c t)
*)

let compute_intersection_list (l: list term): list host_term
  = match map term_to_list l with
  | [] -> []
  | t::q -> fold_left compute_intersection t q

let rec list_of_FStar_term_to_string l: T.Tac string
= match l with
  | [] -> ""
  | t::q -> T.term_to_string t ^ ", " ^ list_of_FStar_term_to_string q

let rec remove_host_term_from_term (ht: host_term) (t: term): bool & term
// returns (b, t')
// b means we have removed it successfully, and t' is t minus ht
// b false implies t = t'
  = match t.t with
  | Tm_FStar ft -> if deq ft ht then (true, with_range Tm_Emp t.range) else (false, t)
  | Tm_Star l r -> let (b, l') = remove_host_term_from_term ht l in
  if b then (true, with_range (Tm_Star l' r) t.range)
  else let (b', r') = remove_host_term_from_term ht r in
    if b' then (true, with_range (Tm_Star l r') t.range) else (false, t)
  | _ -> (false, t)
// should return true in every "good" call

let rec remove_from_vprop (l: list host_term) (t: term): T.Tac term =
  match l with
  | [] -> t
  | ht::q -> remove_from_vprop q ((remove_host_term_from_term ht t)._2)

let adapt_st_comp (c: st_comp) (pre: vprop) (post: vprop): st_comp =
  { u = c.u; res = c.res; pre = pre; post = post }
// 
(*
noeq
type st_comp = { (* ST pre (x:res) post ... x is free in post *)
  u:universe;
  res:term;
  pre:vprop;
  post:vprop
}

type comp =
  | C_Tot      : term -> comp
  | C_ST       : st_comp -> comp
  | C_STAtomic : term -> st_comp -> comp  // inames
  | C_STGhost  : term -> st_comp -> comp  // inames
*)
let adapt_comp (c: comp) (pre: vprop) (post: vprop): comp =
  match c with
  | C_Tot _ -> c // somehow mistake?
  | C_ST st -> C_ST (adapt_st_comp st pre post)
  | C_STAtomic t st -> C_STAtomic t (adapt_st_comp st pre post)
  | C_STGhost t st -> C_STGhost t (adapt_st_comp st pre post)

let add_range r t = with_range (Tm_FStar t) r

let star_with_range r a b = with_range (Tm_Star a b) r

let from_list_to_term (r: range) (l: list host_term): term
  = let l': list vprop = map (add_range r) l in
  let temp: vprop = with_range Tm_Emp r in
  fold_left (star_with_range r) temp l'

#push-options "--z3rlimit_factor 50"
let rec extract_common_frame #g #t #c (inter: list host_term) (ty: st_typing g t c):
  T.Tac (st_typing g t c) (decreases ty)
  = match ty with
  | T_Frame g e c0 frame tot_ty ty' ->
  let f1 = remove_from_vprop inter frame in
  let c1 = add_frame c0 f1 in
  let f2 = from_list_to_term frame.range inter in
  let c2 = add_frame c1 f2 in
  let tot_ty1: Ghost.erased (tot_typing g f1 tm_vprop) = admit() in
  let tot_ty2: Ghost.erased (tot_typing g f2 tm_vprop) = admit() in
  let ty1 = T_Frame g e c0 f1 tot_ty1 ty' in
  let ty2 = T_Frame g e c1 f2 tot_ty2 ty1 in
  let st_eq: st_equiv g c2 c = create_st_equiv g c2 c in
  T_Equiv g e c2 c ty2 st_eq
  // replace frame by frame-common, and put that into common frame
  // and an equiv
  // Example: frame = A * B * C
  // Common: B
  // Result:
  // Equiv (A * B * C) ((A * C) * B)
  // {
  //    Frame B (Frame (A * C) ... )
  // }
  | T_Equiv g e c c' ty' equiv ->
  T_Equiv g e c c' (extract_common_frame inter ty') equiv
  | T_Bind g e1 e2 c1 c2 b x c ty1 tot1 ty2 tot2 ->
  T_Bind g e1 e2 c1 c2 b x c (extract_common_frame inter ty1) tot1 (extract_common_frame inter ty2) tot2
  | _ -> fail g None "No common frame to extract..." // bad, should not happen

// Up to equivalence...
let rec bring_frame_top #g #t #c (ty: st_typing g t c):
// should allow to change the computation, as long as it's equivalent
// we put back the equiv at the end? Not really needed
  T.Tac (c': comp & st_typing g t c' & st_equiv g c' c) (decreases ty)
  = match ty with
  | T_Frame g e c0 frame tot_ty ty' -> // Frame already at the top: Good
  (
    T.print "Frame already at the top, good";
    T.print (term_to_string (comp_pre c0));
    T.print (term_to_string (comp_pre c));
    Mkdtuple3 c ty (create_st_equiv g c c)
  )
  | T_Equiv _ _ c1 _ ty1 eq1 -> 
    let r = bring_frame_top ty1 in
    let c2: comp = r._1 in
    let ty2: st_typing g t c2 = r._2 in
    let eq2: st_equiv g c2 c1 = r._3 in
    let eq12: st_equiv g c2 c = create_st_equiv g c2 c in
    Mkdtuple3 c2 ty2 eq12
  | T_Bind _ e1 e2 c1 c2 b x _ ty1 _ ty2 bcomp2 ->
    (
    let r1 = bring_frame_top ty1 in
    let c1': comp = r1._1 in
    let ty1: st_typing g e1 c1' = r1._2 in
    let r2 = bring_frame_top ty2 in
    let c2': comp = r2._1 in
    let ty2: st_typing _ _ c2' = r2._2 in
    if T_Frame? ty1 && T_Frame? ty2 then
      //let f1 = T_Frame?.frame ty1 in
      let T_Frame g e1 c1' f1 totf1 ty1 = ty1 in
      let ty1: st_typing g e1 c1' = ty1 in
      let b':(b':binder{Mkbinder?.binder_ty b' == comp_res c1'}) =
        {
          binder_ty = comp_res c1'; binder_ppname = b.binder_ppname
        } in
      let T_Frame g e2 c2' f2 totf2 ty2 = ty2 in
      (assume (~(FStar.Set.mem x (Pulse.Typing.Env.dom g)));
      let ty2: st_typing
     (Pulse.Typing.Env.push_binding g
      x
      Pulse.Syntax.Base.ppname_default
      (Pulse.Syntax.Base.comp_res c1'))
      (Pulse.Syntax.Naming.open_st_term_nv e2 (Mkbinder?.binder_ppname b', x)) 
       c2' = ty2 in
      (
        assume (None? (Pulse.Typing.Env.lookup g x) /\ ~(FStar.Set.mem x (Pulse.Syntax.Naming.freevars_st e2)));
        assume (f1 == f2); // To prove
        assume (bind_comp_compatible c1' c2');
        let c': comp_st = bind_comp_out c1' c2' in
        let tot_ty1: Ghost.erased (tot_typing g f1 tm_vprop) = magic() in
        let tot_ty2: bind_comp g x c1' c2' c' = bcomp2 in
        let ty': st_typing g t c' = T_Bind g e1 e2 c1' c2' b' x c' ty1 tot_ty1 ty2 tot_ty2 in
        let e: st_term = {range = t.range; term = Tm_Bind {binder=b; head=e1; body=e2}} in
        let c'': comp_st = add_frame c' f1 in
        let ty'': st_typing g t c'' = T_Frame g e c' f1 totf1 ty' in
        let eq: st_equiv g c'' c = create_st_equiv g c'' c in
        Mkdtuple3 c'' ty'' eq
      ))
    else
      fail g None "Should not have happened..."
    )
  | _ -> fail g None "No frame to bring to the top..." // bad, should not happen

// assuming ty is the typing derivation of the left branch
let get_typing_deriv_and_frame #g #t #c (ty: st_typing g t c):
  T.Tac (c':comp & st_typing g t c' & vprop)
  //: T.Tac (c': comp & st_typing g t c' & st_equiv g c' c) (decreases ty)
  // remove and put an equiv?
= let r = bring_frame_top ty in
let c': comp = r._1 in
let ty': st_typing g t c' = r._2 in
(
  T.print "Bringing frame at the top";
  T.print (st_typing_to_string ty');
let eq: st_equiv g c' c = r._3 in
match ty' with
| T_Frame _ _ c'' f tot ty' -> 
(
  T.print "Weird! Comparing the two preconditions";
  T.print (term_to_string (comp_pre c'));
  T.print "Second precondition";
  T.print (term_to_string (comp_pre c''));
Mkdtuple3 c'' ty' f)
| _ -> fail g None "Did not find a frame at the top..."
)


let check_par
  (allow_inst:bool)
  (g:env)
  (t:st_term{Tm_Par? t.term})
  (pre:term)
  (pre_typing:tot_typing g pre tm_vprop)
  (post_hint:post_hint_opt g)
  (check':bool -> check_t)
  : T.Tac (checker_result_t g pre post_hint) =
  (//assume false;
    let modify_ast = false in
    // if true: Typechecks the left branch only once, and modifies the type derivation
    // if false: Typechecks the left branch twice
    let g = push_context "check_par" t.range g in
    let Tm_Par {pre1=preL; body1=eL; post1=postL; pre2=preR; body2=eR; post2=postR} = t.term in
    // Step 1: Type left branch in full context
    // The postcondition hint might be misleading, so we ignore it (for the moment)
    // TODO
    let (| eL_t, cL_t, eL_typing_t |) = check' allow_inst g eL pre pre_typing None in
    // Step 2: Find the common frame:
    let ty = simplify_st_typing eL_typing_t in
    let inter = compute_intersection_list (collect_frames ty) in
    // let ((| cL, eL_typing, new_preR |) = (
    //let ((| eL, cL, eL_typing |), new_preR) = (
      (*
      if modify_ast then 
        let new_preL = remove_from_vprop inter pre in
        let new_preR = from_list_to_term preR.range inter in
        let ty' = extract_common_frame inter ty in
        let r = get_typing_deriv_and_frame ty' in
        let cL = r._1 in
        let eL_typing = r._2 in
        let new_preR = r._3 in
        admit()
      else
      *)
      // OPTION 2
      // We find the new left and right preconditions, and simply retypecheck
      let new_preL = remove_from_vprop inter pre in
      let new_preR = from_list_to_term preR.range inter in
      let (| preL, preL_typing |) =
        check_term_with_expected_type g new_preL tm_vprop in
      let postL_hint = (if Tm_Unknown? postL.t then None else Some (intro_post_hint g None postL)) in
      let (| eL, cL, eL_typing |) = check' allow_inst g eL preL (E preL_typing) postL_hint
      //(| cL, eL_typing, new_preR |)
    in
    //(T.print "Left precondition:";
    //T.print (term_to_string new_preL);
    //T.print "Right precondition:";
    //T.print (term_to_string new_preR);
    //T.print "Inter:";
    //T.print (st_typing_to_string ty');
    //T.print "Bring frame to top:";
    (*
      let r = bring_frame_top ty' in
      let c': comp = r._1 in
      let ty'': st_typing g t c' = r._2 in
      T.print (st_typing_to_string ty'')
    );*)
    // Option 1
    (*
    let (| preL, preL_typing |) =
      check_term_with_expected_type g new_preL tm_vprop in
    let (| eL, cL, eL_typing |) =
      check' allow_inst g eL preL (E preL_typing) postL_hint in
    *)
    // Option 2

  (*
    T.print "Option 2";
    T.print (comp_to_string cL);
    T.print (term_to_string new_preR);
    T.print "Now, derivation";
    T.print (st_typing_to_string eL_typing);
    T.print "The end!";*)
  let (| preR, preR_typing |) =
    check_term_with_expected_type g new_preR tm_vprop in
  if C_ST? cL
  then
    let cL_typing = MT.st_typing_correctness eL_typing in
    let postR_hint = (if Tm_Unknown? postR.t then None else Some (intro_post_hint g None postR)) in
    let (| eR, cR, eR_typing |) =
      check' allow_inst g eR preR (E preR_typing) postR_hint in

    if C_ST? cR && eq_univ (comp_u cL) (comp_u cR)
    then
      let cR_typing = MT.st_typing_correctness eR_typing in
      let x = fresh g in
      let d = T_Par _ _ _ _ _ x cL_typing cR_typing eL_typing eR_typing in
      repack (try_frame_pre pre_typing d) post_hint
    else fail g (Some eR.range) "par: cR is not stt"
  else fail g (Some eL.range) "par: cL is not stt"
  )
#pop-options