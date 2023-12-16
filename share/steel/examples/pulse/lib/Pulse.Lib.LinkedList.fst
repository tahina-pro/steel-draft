module Pulse.Lib.LinkedList
open Pulse.Lib.Pervasives
open Pulse.Lib.Stick.Util
open FStar.List.Tot
module T = FStar.Tactics
module I = Pulse.Lib.Stick.Util
module FA = Pulse.Lib.Forall.Util

noeq
type node (t:Type0) = {
    head : t;
    tail : llist t;
}

and node_ptr (t:Type0) = ref (node t)

//A nullable pointer to a node
and llist (t:Type0) = option (node_ptr t)

let mk_node #t (hd:t) (tl:llist t) : Tot (node t)
  = {head=hd; tail=tl}

let rec is_list #t (x:llist t) (l:list t)
  : Tot vprop (decreases l)
  = match l with
    | [] -> pure (x == None)
    | head::tl -> 
      exists* (v:node_ptr t) (tail:llist t).
        pure (x == Some v) **
        pts_to v (mk_node head tail) **
        is_list tail tl
    


let is_list_cases #t (x:llist t) (l:list t)
  : Tot vprop 
  = match x with
    | None -> pure (l == [])
    | Some v -> 
      exists* (n:node t) (tl:list t).
        pts_to v n **
        pure (l == n.head::tl) **
        is_list n.tail tl


```pulse
ghost
fn elim_is_list_nil (#t:Type0) (x:llist t) 
  requires is_list x []
  ensures pure(x == None)
{
   unfold (is_list x [])
}
```

```pulse
ghost
fn intro_is_list_nil (#t:Type0) (x:(x:llist t { x == None }))
    requires emp
    ensures is_list x []
{
    fold (is_list x [])
}
```


let norm_tac (_:unit) : T.Tac unit =
    T.mapply (`vprop_equiv_refl)
    
```pulse
ghost
fn elim_is_list_cons (#t:Type0) (x:llist t) (head:t) (tl:list t)
  requires is_list x (head::tl)
  ensures exists* (v:node_ptr t) (tail:llist t).
            pure (x == Some v) **
            pts_to v (mk_node head tail) **
            is_list tail tl
{

    rewrite_by (is_list x (head::tl))
               (exists* (v:node_ptr t)
                        (tail:llist t).
                    pure (x == Some v) **
                    pts_to v (mk_node head tail) **
                    is_list tail tl)
                norm_tac
                ()
}
```

```pulse
ghost
fn intro_is_list_cons (#t:Type0) (x:llist t) (v:node_ptr t) (#node:node t) (#tl:list t)
    requires pts_to v node ** is_list node.tail tl ** pure (x == Some v)
    ensures is_list x (node.head::tl)
{
    rewrite (pts_to v node) as (pts_to v (mk_node node.head node.tail));
    rewrite_by
         (exists* (v:node_ptr t) (tail:llist t).
                pure (x == Some v) **
                pts_to v (mk_node node.head tail) **
                is_list tail tl)
        (is_list x (node.head::tl))
        norm_tac
        ()
}
```

```pulse
ghost
fn cases_of_is_list (#t:Type) (x:llist t) (l:list t)
    requires is_list x l
    ensures is_list_cases x l
{
    match l {
        Nil -> { 
            rewrite (is_list x l) as (is_list x []);
            elim_is_list_nil x;
            rewrite (pure (l == [])) as (is_list_cases x l);
        }
        Cons head tl -> { 
            rewrite (is_list x l) as (is_list x (head::tl));
            elim_is_list_cons x head tl;
            assert pure (Some? x); //surprising that this is needed
            let v = Some?.v x;
            with tail. assert (is_list #t tail tl);
            with w. assert (pts_to w (mk_node head tail));
            rewrite each w as v;
            rewrite each tail as ((mk_node head tail).tail) in (is_list tail tl);
            fold (is_list_cases (Some v) l);
            rewrite (is_list_cases (Some v) l) as
                    (is_list_cases x l)
        }
    }
}
```

```pulse
ghost
fn is_list_of_cases (#t:Type) (x:llist t) (l:list t)
    requires is_list_cases x l
    ensures is_list x l
{
    match x {
        None -> { 
            rewrite (is_list_cases x l) as pure (l==[]);
            rewrite (pure (x == None)) as (is_list x []);
        }
        Some vl -> {
            rewrite (is_list_cases x l) as (is_list_cases (Some vl) l);
            unfold (is_list_cases (Some vl) l);
            intro_is_list_cons x vl;
        }
    }
}
```


```pulse
ghost
fn is_list_cases_none (#t:Type) (x:llist t) (#l:list t)
    requires is_list x l ** pure (x == None)
    ensures is_list x l ** pure (l == [])
{
    cases_of_is_list x l;
    rewrite (is_list_cases x l) as pure (l == []);
    intro_is_list_nil x;
}
```


```pulse
ghost
fn is_list_cases_some (#t:Type) (x:llist t) (v:node_ptr t) (#l:list t) 
    requires is_list x l ** pure (x == Some v)
    ensures exists* (node:node t) (tl:list t).
                pts_to v node **
                pure (l == node.head::tl) **
                is_list node.tail tl
{
    cases_of_is_list x l;
    rewrite (is_list_cases x l) as (is_list_cases (Some v) l);
    unfold (is_list_cases (Some v) l);
}
```

///////////////////////////////////////////////////////////////////////////////

```pulse
fn is_empty (#t:Type) (x:llist t) 
    requires is_list x 'l
    returns b:bool
    ensures is_list x 'l ** pure (b <==> ('l == []))
{
    match x {
        None -> {
            is_list_cases_none x;
            true
        }
        Some vl -> {
            is_list_cases_some x vl;
            intro_is_list_cons x vl;
            false
        }
    }
}
```

```pulse
fn rec length (#t:Type0) (x:llist t)
              (l:erased (list t))
    requires is_list x l
    returns n:nat
    ensures is_list x l ** pure (n == List.Tot.length l)
{
   match x {
    None -> {
        is_list_cases_none x;
        0
    }
    Some vl -> {
        is_list_cases_some x vl;
        let node = !vl;
        with tail tl. assert (is_list #t tail tl);
        rewrite each tail as node.tail; 
        let n = length #t node.tail tl;
        intro_is_list_cons x vl;
        (1 + n)
    }
   }
}
```

let null_llist #t : llist t = None #(node_ptr t)

```pulse
fn create (t:Type)
    requires emp
    returns x:llist t
    ensures is_list x []
{
    intro_is_list_nil #t null_llist;
    null_llist #t
}
```

```pulse
fn cons (#t:Type) (v:t) (x:llist t)
    requires is_list x 'l
    returns y:llist t
    ensures is_list y (v::'l)
{
    let y = alloc (mk_node v x);
    rewrite each x as (mk_node v x).tail in (is_list x 'l);
    intro_is_list_cons (Some y) y;
    Some y
}
```

```pulse
fn rec append (#t:Type0) (x y:llist t)
    requires is_list x 'l1 ** is_list y 'l2 ** pure (x =!= None)
    ensures is_list x (List.Tot.append 'l1 'l2)
{
    let np = Some?.v x;
    is_list_cases_some x np;
    let node = !np;
    with tail tl. assert (is_list #t tail tl);
    rewrite each tail as node.tail;
    match node.tail {
    None -> {
        is_list_cases_none node.tail;
        rewrite (is_list node.tail tl) as (is_list node.tail []);
        unfold (is_list node.tail []);
        np := mk_node node.head y;
        rewrite each y as (mk_node node.head y).tail in (is_list y 'l2);
        intro_is_list_cons x np; 
    }
    Some _ -> {
        append #t node.tail y #tl #'l2;
        intro_is_list_cons x np;
    }
    }
}
```


```pulse
ghost
fn intro_yields_cons (#t:Type) 
                     (v:node_ptr t)
                     (#n:node t)
                     (#tl:erased (list t))
    requires 
        pts_to v n **
        is_list n.tail tl //only there to enable inference of n and tl at call site
    ensures 
        is_list n.tail tl **
        (is_list n.tail tl @==> is_list (Some v) (n.head::tl))
{
    ghost
    fn yields_elim (#t:Type) 
                (v:node_ptr t)
                (n:node t)
                (tl:list t)
        requires 
            pts_to v n ** is_list n.tail tl
        ensures 
            is_list (Some v) (n.head::tl)
    {
        intro_is_list_cons (Some v) v
    };
    intro_stick _ _ _ (fun _ -> yields_elim v n tl);
    with p q. fold (p @==> q)
}
```

```pulse
fn move_next (#t:Type) (x:llist t)
    requires is_list x 'l ** pure (Some? x)
    returns y:llist t
    ensures exists* tl.
        is_list y tl **
        (is_list y tl @==> is_list x 'l) **
        pure (Cons? 'l /\ tl == Cons?.tl 'l)
{ 
    let np = Some?.v x;
    is_list_cases_some x np;
    let node = !np;
    with tail tl. assert (is_list #t tail tl);
    rewrite each tail as node.tail;
    intro_yields_cons np;
    node.tail
}
```

#push-options "--ext 'pulse:env_on_err'"
```pulse
fn length_iter (#t:Type) (x: llist t)
    requires is_list x 'l
    returns n:nat
    ensures is_list x 'l ** pure (n == List.Tot.length 'l)
{
    let mut cur = x;
    let mut ctr = 0; 
    I.refl (is_list x 'l);
    while (
        with ll. assert pts_to cur ll;
        let v = !cur; 
        rewrite (pts_to cur v) as (pts_to cur ll);
        Some? v
    )
    invariant b.  
    exists* n ll suffix.
        pts_to ctr n **
        pts_to cur ll **
        is_list ll suffix **
        (is_list ll suffix @==> is_list x 'l) **
        pure (n == List.Tot.length 'l - List.Tot.length suffix) **
        pure (b == (Some? ll))
    {
        let n = !ctr;
        let ll = !cur;
        with _ll suffix. assert (is_list #t _ll suffix);
        rewrite each _ll as ll;
        let next = move_next ll;
        with tl. assert (is_list next tl);
        I.trans (is_list next tl) (is_list ll suffix) (is_list x 'l);
        cur := next;
        ctr := n + 1;
    };
    with ll _sfx. assert (is_list #t ll _sfx);
    is_list_cases_none ll;
    I.elim _ _;
    let n = !ctr;
    n
}
```

```pulse
fn is_last_cell (#t:Type) (x:llist t)
    requires is_list x 'l ** pure (Some? x)
    returns b:bool
    ensures is_list x 'l ** pure (b == (List.Tot.length 'l = 1))
{
    let np = Some?.v x;
    is_list_cases_some x np;
    let node = !np;
    with tail tl. assert (is_list #t tail tl);
    rewrite each tail as node.tail;
    match node.tail {
        None -> { 
            is_list_cases_none node.tail;
            intro_is_list_cons x np;
            true
        }
        Some vtl -> { 
            is_list_cases_some node.tail vtl;
            intro_is_list_cons node.tail vtl;
            intro_is_list_cons x np;
            false
        }
    }
}
```

#push-options " --query_stats --log_queries" // --debug Pulse.Lib.LinkedList --debug_level SMTQuery  --log_queries"
#restart-solver


```pulse
fn append_at_last_cell (#t:Type) (x y:llist t)
    requires
        is_list x 'l1 **
        is_list y 'l2 **
        pure (Some? x /\ List.Tot.length 'l1 == 1)
    ensures
        is_list x (List.Tot.append 'l1 'l2)
{
    let np = Some?.v x;
    is_list_cases_some x np;
    let node = !np;
    with tail tl. assert (is_list #t tail tl);
    rewrite each tail as node.tail;
    match node.tail {
        None -> {
            is_list_cases_none node.tail;
            elim_is_list_nil node.tail;
            np := mk_node node.head y;
            rewrite each y as (mk_node node.head y).tail in (is_list y 'l2);
            intro_is_list_cons x np; 
        }
        Some vtl -> {
            is_list_cases_some node.tail vtl;
            assert (pure False); //adding this somehow seems necessary; weird
            unreachable ();
        }
    }
}
```

//UGLY! workaround for while invariant instantiation hint
let not_b_if_sfx_1 #t (b:bool) (sfx:list t) : vprop = pure (not b ==> (List.Tot.length sfx = 1))

```pulse
ghost
fn intro_not_b_if_sfx_1_true (#t:Type0) (sfx:list t)
    requires emp
    ensures not_b_if_sfx_1 true sfx
{
    fold (not_b_if_sfx_1 true sfx);
}
```

```pulse
ghost
fn intro_not_b_if_sfx_1_false (#t:Type0) (sfx:list t)
    requires pure (List.Tot.length sfx == 1)
    ensures not_b_if_sfx_1 false sfx
{
    fold (not_b_if_sfx_1 false sfx);
}
```

```pulse
ghost
fn non_empty_list (#t:Type0) (x:llist t)
    requires is_list x 'l ** pure (Cons? 'l)
    ensures is_list x 'l ** pure (Some? x)
{
    elim_is_list_cons x (Cons?.hd 'l) (Cons?.tl 'l);
    with v n. assert (pts_to #(node t) v n);
    with tail tl. assert (is_list #t tail tl);
    rewrite each tail as n.tail;
    intro_is_list_cons x v #n #tl;
}
```

```pulse
ghost
fn forall_intro_is_list_idem (#t:Type) (x:llist t)
    requires emp
    ensures forall* l. is_list x l @==> is_list x l
{
    intro_forall emp (fun l -> I.refl (is_list x l))
}
```

//#push-options "--print_implicits --ugly --print_bound_var_types --print_full_names"// --debug Pulse.Lib.LinkedList --debug_level prover"
open FStar.List.Tot
//ugly, workaround for unification under forall
let something (#a:Type) (x:a) : vprop = emp

//ugly, for admitting equality on forall* 
let rewrite_tac () = T.tadmit()

```pulse
fn move_next_forall (#t:Type) (x:llist t)
    requires is_list x 'l ** pure (Some? x)
    returns y:llist t
    ensures exists* hd tl.
        something hd **
        is_list y tl **
        (forall* tl'. is_list y tl' @==> is_list x (hd::tl')) **
        pure ('l == hd::tl)
{ 
    let np = Some?.v x;
    is_list_cases_some x np;
    let node = !np;
    with tail tl. assert (is_list #t tail tl);
    rewrite each tail as node.tail;
    ghost fn aux (tl':list t)
        requires pts_to np node
        ensures is_list node.tail tl' @==> is_list x (node.head::tl')
    {
        ghost fn aux (_:unit)
        requires pts_to np node ** is_list node.tail tl'
        ensures is_list x (node.head::tl')
        {
            intro_is_list_cons x np;
        };
        intro_stick _ _ _ aux;
        fold (is_list node.tail tl' @==> is_list x (node.head::tl'));
    };
    FA.intro _ aux;
    fold (something node.head);
    node.tail
}
```

```pulse
fn append_iter (#t:Type) (x y:llist t)
    requires is_list x 'l1 ** is_list y 'l2 ** pure (Some? x /\ List.Tot.length 'l1 >= 1)
    ensures is_list x (List.Tot.append 'l1 'l2)
{
    let mut cur = x;
    forall_intro_is_list_idem x;
    rewrite_by (forall* l. is_list x l @==> is_list x l)
               (forall* l. is_list x l @==> is_list x ([]@l))
               norm_tac ();
    fold (something #(list t) []);
    intro_not_b_if_sfx_1_true 'l1;
    while (
        with _b _sfx. unfold (not_b_if_sfx_1 #t _b _sfx);
        with pfx. assert (something #(list t) pfx);
        unfold (something #(list t) pfx);
        let l = !cur;
        with _ll sfx. assert (is_list #t _ll sfx);
        rewrite each _ll as l in (is_list _ll sfx);
        rewrite_by (forall* sfx'. is_list _ll sfx' @==> is_list x (pfx @ sfx'))
                   (forall* sfx'. is_list l sfx' @==> is_list x (pfx @ sfx'))
                   rewrite_tac ();
        let b = is_last_cell l;
        if b 
        { 
            intro_not_b_if_sfx_1_false sfx;
            fold (something pfx);
            false
        }
        else 
        {
            let next = move_next_forall l;
            with tl. assert (is_list next tl);
            with hd. assert (something #t hd);
            FA.trans_compose 
                (is_list next) (is_list l) (is_list x)
                (fun tl -> hd :: tl)
                (fun tl -> pfx @ tl);
            List.Tot.Properties.append_assoc pfx [Cons?.hd sfx] tl;
            rewrite_by (forall* tl. is_list next tl @==> is_list x (pfx @ (hd::tl)))
                       (forall* tl. is_list next tl @==> is_list x ((pfx@[hd])@tl))
                       rewrite_tac ();
            unfold (something #t hd);
            fold (something #(list t) (pfx@[hd]));
            cur := next;
            intro_not_b_if_sfx_1_true tl;
            non_empty_list next;
            true
        }
    )
    invariant b.
    exists* ll pfx sfx.
        something pfx **
        pts_to cur ll **
        is_list ll sfx **
        (forall* sfx'. is_list ll sfx' @==> is_list x (pfx @ sfx')) **
        not_b_if_sfx_1 b sfx **
        pure (List.Tot.length sfx >= 1 /\
              pfx@sfx == 'l1 /\
              Some? ll)
    { () };
    let last = !cur;
    with pfx. assert (something #(list t) pfx);
    with _ll sfx. assert (is_list #t _ll sfx);
    rewrite each _ll as last in (is_list _ll sfx);
    rewrite_by (forall* sfx'. is_list _ll sfx' @==> is_list x (pfx @ sfx'))
               (forall* sfx'. is_list last sfx' @==> is_list x (pfx @ sfx'))
               rewrite_tac ();
    with _b _sfx. unfold (not_b_if_sfx_1 #t _b _sfx);
    assert (pure (List.Tot.length sfx == 1));
    append_at_last_cell last y;
    FA.elim_forall_imp (is_list last) (fun sfx' -> is_list x (pfx @ sfx')) (sfx@'l2);
    List.Tot.Properties.append_assoc pfx sfx 'l2;
    unfold (something #(list t) pfx);
    with l. rewrite (is_list x l) as is_list x (List.Tot.append 'l1 'l2);
}
```

// let rec take (n:nat) (l:list 't { n < List.Tot.length l })
//   : list 'tg
//   = if n = 0 then []
//     else List.Tot.hd l :: take (n-1) (List.Tot.tl l)

//  let rec drop (n:nat) (l:list 't { n < List.Tot.length l })
//   : list 't
//   = if n = 0 then l
//     else drop (n-1) (List.Tot.tl l)
       
// ```pulse
// fn split (#t:Type) (x:llist t) (n:nat) (#l:(l:erased (list t) { n < List.Tot.length l }))
//     requires is_list x l
//     returns y:llist t
//     ensures is_list x (take n l) ** is_list y (drop n l)
// {
//     admit()
// }
// ```
