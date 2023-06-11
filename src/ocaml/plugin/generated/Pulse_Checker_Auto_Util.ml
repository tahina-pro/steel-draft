open Prims
type ('g, 'ctxt, 'gu, 'ctxtu) continuation_elaborator =
  unit Pulse_Checker_Common.post_hint_opt ->
    (unit, unit, unit) Pulse_Checker_Common.checker_result_t ->
      ((unit, unit, unit) Pulse_Checker_Common.checker_result_t, unit)
        FStar_Tactics_Effect.tac_repr
let (k_elab_unit :
  Pulse_Typing_Env.env ->
    Pulse_Syntax_Base.term ->
      (unit, unit, unit, unit) continuation_elaborator)
  =
  fun uu___1 ->
    fun uu___ ->
      (fun g ->
         fun ctxt ->
           fun p ->
             fun r ->
               Obj.magic (FStar_Tactics_Effect.lift_div_tac (fun uu___ -> r)))
        uu___1 uu___
let (k_elab_trans :
  Pulse_Typing_Env.env ->
    Pulse_Typing_Env.env ->
      Pulse_Typing_Env.env ->
        Pulse_Syntax_Base.term ->
          Pulse_Syntax_Base.term ->
            Pulse_Syntax_Base.term ->
              (unit, unit, unit, unit) continuation_elaborator ->
                (unit, unit, unit, unit) continuation_elaborator ->
                  (unit, unit, unit, unit) continuation_elaborator)
  =
  fun g0 ->
    fun g1 ->
      fun g2 ->
        fun ctxt0 ->
          fun ctxt1 ->
            fun ctxt2 ->
              fun k0 ->
                fun k1 ->
                  fun post_hint ->
                    fun res ->
                      FStar_Tactics_Effect.tac_bind
                        (FStar_Sealed.seal
                           (Obj.magic
                              (FStar_Range.mk_range
                                 "Pulse.Checker.Auto.Util.fst"
                                 (Prims.of_int (24)) (Prims.of_int (39))
                                 (Prims.of_int (24)) (Prims.of_int (57)))))
                        (FStar_Sealed.seal
                           (Obj.magic
                              (FStar_Range.mk_range
                                 "Pulse.Checker.Auto.Util.fst"
                                 (Prims.of_int (24)) (Prims.of_int (26))
                                 (Prims.of_int (24)) (Prims.of_int (57)))))
                        (Obj.magic (k1 post_hint res))
                        (fun uu___ ->
                           (fun uu___ -> Obj.magic (k0 post_hint uu___))
                             uu___)
let (comp_st_with_post :
  Pulse_Syntax_Base.comp_st ->
    Pulse_Syntax_Base.term -> Pulse_Syntax_Base.comp_st)
  =
  fun c ->
    fun post ->
      match c with
      | Pulse_Syntax_Base.C_ST st ->
          Pulse_Syntax_Base.C_ST
            {
              Pulse_Syntax_Base.u = (st.Pulse_Syntax_Base.u);
              Pulse_Syntax_Base.res = (st.Pulse_Syntax_Base.res);
              Pulse_Syntax_Base.pre = (st.Pulse_Syntax_Base.pre);
              Pulse_Syntax_Base.post = post
            }
      | Pulse_Syntax_Base.C_STGhost (i, st) ->
          Pulse_Syntax_Base.C_STGhost
            (i,
              {
                Pulse_Syntax_Base.u = (st.Pulse_Syntax_Base.u);
                Pulse_Syntax_Base.res = (st.Pulse_Syntax_Base.res);
                Pulse_Syntax_Base.pre = (st.Pulse_Syntax_Base.pre);
                Pulse_Syntax_Base.post = post
              })
      | Pulse_Syntax_Base.C_STAtomic (i, st) ->
          Pulse_Syntax_Base.C_STAtomic
            (i,
              {
                Pulse_Syntax_Base.u = (st.Pulse_Syntax_Base.u);
                Pulse_Syntax_Base.res = (st.Pulse_Syntax_Base.res);
                Pulse_Syntax_Base.pre = (st.Pulse_Syntax_Base.pre);
                Pulse_Syntax_Base.post = post
              })
let (st_equiv_post :
  Pulse_Typing_Env.env ->
    Pulse_Syntax_Base.st_term ->
      Pulse_Syntax_Base.comp_st ->
        (unit, unit, unit) Pulse_Typing.st_typing ->
          Pulse_Syntax_Base.term ->
            unit -> (unit, unit, unit) Pulse_Typing.st_typing)
  =
  fun g ->
    fun t ->
      fun c ->
        fun d ->
          fun post ->
            fun veq ->
              let c' = comp_st_with_post c post in
              let uu___ =
                Pulse_Typing_Metatheory.st_comp_typing_inversion g
                  (Pulse_Syntax_Base.st_comp_of_comp c)
                  (Pulse_Typing_Metatheory.comp_typing_inversion g c
                     (Pulse_Typing_Metatheory.st_typing_correctness g t c d)) in
              match uu___ with
              | FStar_Pervasives.Mkdtuple4 (u_of, pre_typing, x, post_typing)
                  ->
                  let st_equiv =
                    Pulse_Typing.ST_VPropEquiv
                      (g, c, c', x, (), (), (), (), ()) in
                  Pulse_Typing.T_Equiv (g, t, c, c', d, st_equiv)
let (simplify_post :
  Pulse_Typing_Env.env ->
    Pulse_Syntax_Base.st_term ->
      Pulse_Syntax_Base.comp_st ->
        (unit, unit, unit) Pulse_Typing.st_typing ->
          Pulse_Syntax_Base.term -> (unit, unit, unit) Pulse_Typing.st_typing)
  =
  fun g ->
    fun t -> fun c -> fun d -> fun post -> st_equiv_post g t c d post ()
let (k_elab_equiv_continutation :
  Pulse_Typing_Env.env ->
    Pulse_Typing_Env.env ->
      Pulse_Syntax_Base.term ->
        Pulse_Syntax_Base.term ->
          Pulse_Syntax_Base.term ->
            (unit, unit, unit, unit) continuation_elaborator ->
              unit -> (unit, unit, unit, unit) continuation_elaborator)
  =
  fun g1 ->
    fun g2 ->
      fun ctxt ->
        fun ctxt1 ->
          fun ctxt2 ->
            fun k ->
              fun d ->
                fun post_hint ->
                  fun res ->
                    FStar_Tactics_Effect.tac_bind
                      (FStar_Sealed.seal
                         (Obj.magic
                            (FStar_Range.mk_range
                               "Pulse.Checker.Auto.Util.fst"
                               (Prims.of_int (72)) (Prims.of_int (60))
                               (Prims.of_int (75)) (Prims.of_int (33)))))
                      (FStar_Sealed.seal
                         (Obj.magic
                            (FStar_Range.mk_range
                               "Pulse.Checker.Auto.Util.fst"
                               (Prims.of_int (76)) (Prims.of_int (4))
                               (Prims.of_int (86)) (Prims.of_int (34)))))
                      (FStar_Tactics_Effect.lift_div_tac
                         (fun uu___ ->
                            FStar_Pervasives.Mkdtuple3
                              (Pulse_Syntax_Base.Tm_Emp, (), ())))
                      (fun uu___ ->
                         (fun framing_token ->
                            Obj.magic
                              (FStar_Tactics_Effect.tac_bind
                                 (FStar_Sealed.seal
                                    (Obj.magic
                                       (FStar_Range.mk_range
                                          "Pulse.Checker.Auto.Util.fst"
                                          (Prims.of_int (77))
                                          (Prims.of_int (26))
                                          (Prims.of_int (77))
                                          (Prims.of_int (29)))))
                                 (FStar_Sealed.seal
                                    (Obj.magic
                                       (FStar_Range.mk_range
                                          "Pulse.Checker.Auto.Util.fst"
                                          (Prims.of_int (76))
                                          (Prims.of_int (4))
                                          (Prims.of_int (86))
                                          (Prims.of_int (34)))))
                                 (FStar_Tactics_Effect.lift_div_tac
                                    (fun uu___ -> res))
                                 (fun uu___ ->
                                    (fun uu___ ->
                                       match uu___ with
                                       | FStar_Pervasives.Mkdtuple3
                                           (st, c, st_d) ->
                                           if
                                             Prims.op_Negation
                                               (Pulse_Syntax_Base.stateful_comp
                                                  c)
                                           then
                                             Obj.magic
                                               (k post_hint
                                                  (FStar_Pervasives.Mkdtuple3
                                                     (st, c, st_d)))
                                           else
                                             Obj.magic
                                               (FStar_Tactics_Effect.tac_bind
                                                  (FStar_Sealed.seal
                                                     (Obj.magic
                                                        (FStar_Range.mk_range
                                                           "Pulse.Checker.Auto.Util.fst"
                                                           (Prims.of_int (81))
                                                           (Prims.of_int (18))
                                                           (Prims.of_int (81))
                                                           (Prims.of_int (95)))))
                                                  (FStar_Sealed.seal
                                                     (Obj.magic
                                                        (FStar_Range.mk_range
                                                           "Pulse.Checker.Auto.Util.fst"
                                                           (Prims.of_int (79))
                                                           (Prims.of_int (6))
                                                           (Prims.of_int (86))
                                                           (Prims.of_int (34)))))
                                                  (FStar_Tactics_Effect.lift_div_tac
                                                     (fun uu___2 ->
                                                        Pulse_Typing_Metatheory.st_comp_typing_inversion
                                                          g2
                                                          (Pulse_Syntax_Base.st_comp_of_comp
                                                             c)
                                                          (Pulse_Typing_Metatheory.comp_typing_inversion
                                                             g2 c
                                                             (Pulse_Typing_Metatheory.st_typing_correctness
                                                                g2 st c st_d))))
                                                  (fun uu___2 ->
                                                     (fun uu___2 ->
                                                        match uu___2 with
                                                        | FStar_Pervasives.Mkdtuple4
                                                            (uu___3,
                                                             pre_typing,
                                                             uu___4, uu___5)
                                                            ->
                                                            Obj.magic
                                                              (FStar_Tactics_Effect.tac_bind
                                                                 (FStar_Sealed.seal
                                                                    (
                                                                    Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Auto.Util.fst"
                                                                    (Prims.of_int (83))
                                                                    (Prims.of_int (6))
                                                                    (Prims.of_int (83))
                                                                    (Prims.of_int (95)))))
                                                                 (FStar_Sealed.seal
                                                                    (
                                                                    Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Auto.Util.fst"
                                                                    (Prims.of_int (81))
                                                                    (Prims.of_int (99))
                                                                    (Prims.of_int (86))
                                                                    (Prims.of_int (34)))))
                                                                 (FStar_Tactics_Effect.lift_div_tac
                                                                    (
                                                                    fun
                                                                    uu___6 ->
                                                                    Pulse_Checker_Framing.apply_frame
                                                                    g2 st
                                                                    ctxt1 ()
                                                                    c st_d
                                                                    framing_token))
                                                                 (fun uu___6
                                                                    ->
                                                                    (fun
                                                                    uu___6 ->
                                                                    match uu___6
                                                                    with
                                                                    | 
                                                                    Prims.Mkdtuple2
                                                                    (c',
                                                                    st_d') ->
                                                                    Obj.magic
                                                                    (FStar_Tactics_Effect.tac_bind
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Auto.Util.fst"
                                                                    (Prims.of_int (85))
                                                                    (Prims.of_int (16))
                                                                    (Prims.of_int (85))
                                                                    (Prims.of_int (49)))))
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Auto.Util.fst"
                                                                    (Prims.of_int (86))
                                                                    (Prims.of_int (4))
                                                                    (Prims.of_int (86))
                                                                    (Prims.of_int (34)))))
                                                                    (FStar_Tactics_Effect.lift_div_tac
                                                                    (fun
                                                                    uu___7 ->
                                                                    simplify_post
                                                                    g2 st c'
                                                                    st_d'
                                                                    (Pulse_Syntax_Base.comp_post
                                                                    c)))
                                                                    (fun
                                                                    uu___7 ->
                                                                    (fun
                                                                    st_d'1 ->
                                                                    Obj.magic
                                                                    (k
                                                                    post_hint
                                                                    (FStar_Pervasives.Mkdtuple3
                                                                    (st,
                                                                    (comp_st_with_post
                                                                    c'
                                                                    (Pulse_Syntax_Base.comp_post
                                                                    c)),
                                                                    st_d'1))))
                                                                    uu___7)))
                                                                    uu___6)))
                                                       uu___2))) uu___)))
                           uu___)
let (k_elab_equiv_prefix :
  Pulse_Typing_Env.env ->
    Pulse_Typing_Env.env ->
      Pulse_Syntax_Base.term ->
        Pulse_Syntax_Base.term ->
          Pulse_Syntax_Base.term ->
            (unit, unit, unit, unit) continuation_elaborator ->
              unit -> (unit, unit, unit, unit) continuation_elaborator)
  =
  fun g1 ->
    fun g2 ->
      fun ctxt1 ->
        fun ctxt2 ->
          fun ctxt ->
            fun k ->
              fun d ->
                fun post_hint ->
                  fun res ->
                    FStar_Tactics_Effect.tac_bind
                      (FStar_Sealed.seal
                         (Obj.magic
                            (FStar_Range.mk_range
                               "Pulse.Checker.Auto.Util.fst"
                               (Prims.of_int (95)) (Prims.of_int (60))
                               (Prims.of_int (97)) (Prims.of_int (31)))))
                      (FStar_Sealed.seal
                         (Obj.magic
                            (FStar_Range.mk_range
                               "Pulse.Checker.Auto.Util.fst"
                               (Prims.of_int (98)) (Prims.of_int (4))
                               (Prims.of_int (113)) (Prims.of_int (11)))))
                      (FStar_Tactics_Effect.lift_div_tac
                         (fun uu___ ->
                            FStar_Pervasives.Mkdtuple3
                              (Pulse_Syntax_Base.Tm_Emp, (), ())))
                      (fun uu___ ->
                         (fun framing_token ->
                            Obj.magic
                              (FStar_Tactics_Effect.tac_bind
                                 (FStar_Sealed.seal
                                    (Obj.magic
                                       (FStar_Range.mk_range
                                          "Pulse.Checker.Auto.Util.fst"
                                          (Prims.of_int (99))
                                          (Prims.of_int (12))
                                          (Prims.of_int (99))
                                          (Prims.of_int (27)))))
                                 (FStar_Sealed.seal
                                    (Obj.magic
                                       (FStar_Range.mk_range
                                          "Pulse.Checker.Auto.Util.fst"
                                          (Prims.of_int (99))
                                          (Prims.of_int (30))
                                          (Prims.of_int (113))
                                          (Prims.of_int (11)))))
                                 (Obj.magic (k post_hint res))
                                 (fun res1 ->
                                    FStar_Tactics_Effect.lift_div_tac
                                      (fun uu___ ->
                                         match res1 with
                                         | FStar_Pervasives.Mkdtuple3
                                             (st, c, st_d) ->
                                             if
                                               Prims.op_Negation
                                                 (Pulse_Syntax_Base.stateful_comp
                                                    c)
                                             then
                                               FStar_Pervasives.Mkdtuple3
                                                 (st, c, st_d)
                                             else
                                               (match Pulse_Typing_Metatheory.st_comp_typing_inversion
                                                        g1
                                                        (Pulse_Syntax_Base.st_comp_of_comp
                                                           c)
                                                        (Pulse_Typing_Metatheory.comp_typing_inversion
                                                           g1 c
                                                           (Pulse_Typing_Metatheory.st_typing_correctness
                                                              g1 st c st_d))
                                                with
                                                | FStar_Pervasives.Mkdtuple4
                                                    (uu___2, pre_typing,
                                                     uu___3, uu___4)
                                                    ->
                                                    (match Pulse_Checker_Framing.apply_frame
                                                             g1 st ctxt2 () c
                                                             st_d
                                                             framing_token
                                                     with
                                                     | Prims.Mkdtuple2
                                                         (c', st_d') ->
                                                         FStar_Pervasives.Mkdtuple3
                                                           (st,
                                                             (comp_st_with_post
                                                                c'
                                                                (Pulse_Syntax_Base.comp_post
                                                                   c)),
                                                             (simplify_post
                                                                g1 st c'
                                                                st_d'
                                                                (Pulse_Syntax_Base.comp_post
                                                                   c)))))))))
                           uu___)
let (k_elab_equiv :
  Pulse_Typing_Env.env ->
    Pulse_Typing_Env.env ->
      Pulse_Syntax_Base.term ->
        Pulse_Syntax_Base.term ->
          Pulse_Syntax_Base.term ->
            Pulse_Syntax_Base.term ->
              (unit, unit, unit, unit) continuation_elaborator ->
                unit ->
                  unit -> (unit, unit, unit, unit) continuation_elaborator)
  =
  fun g1 ->
    fun g2 ->
      fun ctxt1 ->
        fun ctxt1' ->
          fun ctxt2 ->
            fun ctxt2' ->
              fun k ->
                fun d1 ->
                  fun d2 ->
                    let k1 =
                      k_elab_equiv_continutation g1 g2 ctxt1 ctxt2 ctxt2' k
                        () in
                    let k2 =
                      k_elab_equiv_prefix g1 g2 ctxt1 ctxt1' ctxt2' k1 () in
                    k2
let rec (list_as_vprop' :
  Pulse_Syntax_Base.vprop ->
    Pulse_Syntax_Base.vprop Prims.list -> Pulse_Syntax_Base.vprop)
  =
  fun vp ->
    fun fvps ->
      match fvps with
      | [] -> vp
      | hd::tl -> list_as_vprop' (Pulse_Syntax_Base.Tm_Star (vp, hd)) tl
let rec (canon_right_aux :
  Pulse_Typing_Env.env ->
    Pulse_Syntax_Base.vprop Prims.list ->
      (Pulse_Syntax_Base.vprop ->
         (Prims.bool, unit) FStar_Tactics_Effect.tac_repr)
        ->
        ((Pulse_Syntax_Base.vprop Prims.list,
           Pulse_Syntax_Base.vprop Prims.list, unit) FStar_Pervasives.dtuple3,
          unit) FStar_Tactics_Effect.tac_repr)
  =
  fun uu___2 ->
    fun uu___1 ->
      fun uu___ ->
        (fun g ->
           fun vps ->
             fun f ->
               match vps with
               | [] ->
                   Obj.magic
                     (Obj.repr
                        (FStar_Tactics_Effect.lift_div_tac
                           (fun uu___ ->
                              FStar_Pervasives.Mkdtuple3 ([], [], ()))))
               | hd::rest ->
                   Obj.magic
                     (Obj.repr
                        (FStar_Tactics_Effect.tac_bind
                           (FStar_Sealed.seal
                              (Obj.magic
                                 (FStar_Range.mk_range
                                    "Pulse.Checker.Auto.Util.fst"
                                    (Prims.of_int (142)) (Prims.of_int (7))
                                    (Prims.of_int (142)) (Prims.of_int (11)))))
                           (FStar_Sealed.seal
                              (Obj.magic
                                 (FStar_Range.mk_range
                                    "Pulse.Checker.Auto.Util.fst"
                                    (Prims.of_int (142)) (Prims.of_int (4))
                                    (Prims.of_int (166)) (Prims.of_int (7)))))
                           (Obj.magic (f hd))
                           (fun uu___ ->
                              (fun uu___ ->
                                 if uu___
                                 then
                                   Obj.magic
                                     (FStar_Tactics_Effect.tac_bind
                                        (FStar_Sealed.seal
                                           (Obj.magic
                                              (FStar_Range.mk_range
                                                 "Pulse.Checker.Auto.Util.fst"
                                                 (Prims.of_int (144))
                                                 (Prims.of_int (32))
                                                 (Prims.of_int (144))
                                                 (Prims.of_int (56)))))
                                        (FStar_Sealed.seal
                                           (Obj.magic
                                              (FStar_Range.mk_range
                                                 "Pulse.Checker.Auto.Util.fst"
                                                 (Prims.of_int (143))
                                                 (Prims.of_int (14))
                                                 (Prims.of_int (160))
                                                 (Prims.of_int (34)))))
                                        (Obj.magic (canon_right_aux g rest f))
                                        (fun uu___1 ->
                                           FStar_Tactics_Effect.lift_div_tac
                                             (fun uu___2 ->
                                                match uu___1 with
                                                | FStar_Pervasives.Mkdtuple3
                                                    (vps', fvps, uu___3) ->
                                                    FStar_Pervasives.Mkdtuple3
                                                      (vps', (hd :: fvps),
                                                        ()))))
                                 else
                                   Obj.magic
                                     (FStar_Tactics_Effect.tac_bind
                                        (FStar_Sealed.seal
                                           (Obj.magic
                                              (FStar_Range.mk_range
                                                 "Pulse.Checker.Auto.Util.fst"
                                                 (Prims.of_int (163))
                                                 (Prims.of_int (33))
                                                 (Prims.of_int (163))
                                                 (Prims.of_int (57)))))
                                        (FStar_Sealed.seal
                                           (Obj.magic
                                              (FStar_Range.mk_range
                                                 "Pulse.Checker.Auto.Util.fst"
                                                 (Prims.of_int (162))
                                                 (Prims.of_int (14))
                                                 (Prims.of_int (165))
                                                 (Prims.of_int (33)))))
                                        (Obj.magic (canon_right_aux g rest f))
                                        (fun uu___2 ->
                                           FStar_Tactics_Effect.lift_div_tac
                                             (fun uu___3 ->
                                                match uu___2 with
                                                | FStar_Pervasives.Mkdtuple3
                                                    (vps', pures, uu___4) ->
                                                    FStar_Pervasives.Mkdtuple3
                                                      ((hd :: vps'), pures,
                                                        ()))))) uu___))))
          uu___2 uu___1 uu___
let (canon_right :
  Pulse_Typing_Env.env ->
    Pulse_Syntax_Base.term ->
      unit ->
        (Pulse_Syntax_Base.vprop ->
           (Prims.bool, unit) FStar_Tactics_Effect.tac_repr)
          ->
          ((Pulse_Syntax_Base.term, unit,
             (unit, unit, unit, unit) continuation_elaborator)
             FStar_Pervasives.dtuple3,
            unit) FStar_Tactics_Effect.tac_repr)
  =
  fun g ->
    fun ctxt ->
      fun ctxt_typing ->
        fun f ->
          FStar_Tactics_Effect.tac_bind
            (FStar_Sealed.seal
               (Obj.magic
                  (FStar_Range.mk_range "Pulse.Checker.Auto.Util.fst"
                     (Prims.of_int (173)) (Prims.of_int (33))
                     (Prims.of_int (173)) (Prims.of_int (73)))))
            (FStar_Sealed.seal
               (Obj.magic
                  (FStar_Range.mk_range "Pulse.Checker.Auto.Util.fst"
                     (Prims.of_int (173)) (Prims.of_int (3))
                     (Prims.of_int (178)) (Prims.of_int (104)))))
            (Obj.magic
               (canon_right_aux g
                  (Pulse_Checker_VPropEquiv.vprop_as_list ctxt) f))
            (fun uu___ ->
               FStar_Tactics_Effect.lift_div_tac
                 (fun uu___1 ->
                    match uu___ with
                    | FStar_Pervasives.Mkdtuple3 (vps', pures, veq) ->
                        FStar_Pervasives.Mkdtuple3
                          ((list_as_vprop'
                              (Pulse_Checker_VPropEquiv.list_as_vprop vps')
                              pures), (),
                            (k_elab_equiv g g ctxt ctxt ctxt
                               (list_as_vprop'
                                  (Pulse_Checker_VPropEquiv.list_as_vprop
                                     vps') pures) (k_elab_unit g ctxt) () ()))))
let (continuation_elaborator_with_bind :
  Pulse_Typing_Env.env ->
    Pulse_Syntax_Base.term ->
      Pulse_Syntax_Base.comp ->
        Pulse_Syntax_Base.st_term ->
          (unit, unit, unit) Pulse_Typing.st_typing ->
            unit ->
              ((Pulse_Syntax_Base.var,
                 (unit, unit, unit, unit) continuation_elaborator)
                 Prims.dtuple2,
                unit) FStar_Tactics_Effect.tac_repr)
  =
  fun uu___5 ->
    fun uu___4 ->
      fun uu___3 ->
        fun uu___2 ->
          fun uu___1 ->
            fun uu___ ->
              (fun g ->
                 fun ctxt ->
                   fun c1 ->
                     fun e1 ->
                       fun e1_typing ->
                         fun ctxt_pre1_typing ->
                           Obj.magic
                             (FStar_Tactics_Effect.lift_div_tac
                                (fun uu___ ->
                                   match Pulse_Checker_Framing.apply_frame g
                                           e1
                                           (Pulse_Syntax_Base.Tm_Star
                                              (ctxt,
                                                (Pulse_Syntax_Base.comp_pre
                                                   c1))) () c1 e1_typing
                                           (FStar_Pervasives.Mkdtuple3
                                              (ctxt, (), ()))
                                   with
                                   | Prims.Mkdtuple2 (c11, e1_typing1) ->
                                       (match Pulse_Typing_Metatheory.st_comp_typing_inversion
                                                g
                                                (Pulse_Syntax_Base.st_comp_of_comp
                                                   c11)
                                                (Pulse_Typing_Metatheory.comp_typing_inversion
                                                   g c11
                                                   (Pulse_Typing_Metatheory.st_typing_correctness
                                                      g e1 c11 e1_typing1))
                                        with
                                        | FStar_Pervasives.Mkdtuple4
                                            (u_of_1, pre_typing, uu___1,
                                             uu___2)
                                            ->
                                            Prims.Mkdtuple2
                                              ((Pulse_Typing.fresh g),
                                                ((fun post_hint ->
                                                    fun res ->
                                                      FStar_Tactics_Effect.tac_bind
                                                        (FStar_Sealed.seal
                                                           (Obj.magic
                                                              (FStar_Range.mk_range
                                                                 "Pulse.Checker.Auto.Util.fst"
                                                                 (Prims.of_int (211))
                                                                 (Prims.of_int (34))
                                                                 (Prims.of_int (211))
                                                                 (Prims.of_int (37)))))
                                                        (FStar_Sealed.seal
                                                           (Obj.magic
                                                              (FStar_Range.mk_range
                                                                 "Pulse.Checker.Auto.Util.fst"
                                                                 (Prims.of_int (210))
                                                                 (Prims.of_int (24))
                                                                 (Prims.of_int (243))
                                                                 (Prims.of_int (5)))))
                                                        (FStar_Tactics_Effect.lift_div_tac
                                                           (fun uu___3 -> res))
                                                        (fun uu___3 ->
                                                           (fun uu___3 ->
                                                              match uu___3
                                                              with
                                                              | FStar_Pervasives.Mkdtuple3
                                                                  (e2, c2,
                                                                   e2_typing)
                                                                  ->
                                                                  if
                                                                    Prims.op_Negation
                                                                    (Pulse_Syntax_Base.stateful_comp
                                                                    c2)
                                                                  then
                                                                    Obj.magic
                                                                    (Obj.repr
                                                                    (FStar_Tactics_V2_Derived.fail
                                                                    "Unexpected non-stateful comp in continuation elaborate"))
                                                                  else
                                                                    Obj.magic
                                                                    (Obj.repr
                                                                    (FStar_Tactics_Effect.tac_bind
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Auto.Util.fst"
                                                                    (Prims.of_int (215))
                                                                    (Prims.of_int (43))
                                                                    (Prims.of_int (215))
                                                                    (Prims.of_int (52)))))
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Auto.Util.fst"
                                                                    (Prims.of_int (215))
                                                                    (Prims.of_int (55))
                                                                    (Prims.of_int (242))
                                                                    (Prims.of_int (7)))))
                                                                    (FStar_Tactics_Effect.lift_div_tac
                                                                    (fun
                                                                    uu___5 ->
                                                                    e2_typing))
                                                                    (fun
                                                                    uu___5 ->
                                                                    (fun
                                                                    e2_typing1
                                                                    ->
                                                                    Obj.magic
                                                                    (FStar_Tactics_Effect.tac_bind
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Auto.Util.fst"
                                                                    (Prims.of_int (216))
                                                                    (Prims.of_int (22))
                                                                    (Prims.of_int (216))
                                                                    (Prims.of_int (40)))))
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Auto.Util.fst"
                                                                    (Prims.of_int (227))
                                                                    (Prims.of_int (6))
                                                                    (Prims.of_int (242))
                                                                    (Prims.of_int (7)))))
                                                                    (FStar_Tactics_Effect.lift_div_tac
                                                                    (fun
                                                                    uu___5 ->
                                                                    Pulse_Syntax_Naming.close_st_term
                                                                    e2
                                                                    (Pulse_Typing.fresh
                                                                    g)))
                                                                    (fun
                                                                    uu___5 ->
                                                                    (fun
                                                                    e2_closed
                                                                    ->
                                                                    if
                                                                    FStar_Set.mem
                                                                    (Pulse_Typing.fresh
                                                                    g)
                                                                    (Pulse_Syntax_Naming.freevars
                                                                    (Pulse_Syntax_Base.comp_post
                                                                    c2))
                                                                    then
                                                                    Obj.magic
                                                                    (Obj.repr
                                                                    (FStar_Tactics_V2_Derived.fail
                                                                    "Impossible"))
                                                                    else
                                                                    Obj.magic
                                                                    (Obj.repr
                                                                    (FStar_Tactics_Effect.tac_bind
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Auto.Util.fst"
                                                                    (Prims.of_int (231))
                                                                    (Prims.of_int (10))
                                                                    (Prims.of_int (231))
                                                                    (Prims.of_int (88)))))
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Auto.Util.fst"
                                                                    (Prims.of_int (229))
                                                                    (Prims.of_int (11))
                                                                    (Prims.of_int (242))
                                                                    (Prims.of_int (7)))))
                                                                    (Obj.magic
                                                                    (Pulse_Checker_Bind.bind_res_and_post_typing
                                                                    g
                                                                    (Pulse_Syntax_Base.st_comp_of_comp
                                                                    c2)
                                                                    (Pulse_Typing.fresh
                                                                    g)
                                                                    post_hint))
                                                                    (fun
                                                                    uu___6 ->
                                                                    (fun
                                                                    uu___6 ->
                                                                    match uu___6
                                                                    with
                                                                    | 
                                                                    (t_typing,
                                                                    post_typing)
                                                                    ->
                                                                    Obj.magic
                                                                    (FStar_Tactics_Effect.tac_bind
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Auto.Util.fst"
                                                                    (Prims.of_int (233))
                                                                    (Prims.of_int (10))
                                                                    (Prims.of_int (239))
                                                                    (Prims.of_int (23)))))
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Auto.Util.fst"
                                                                    (Prims.of_int (231))
                                                                    (Prims.of_int (91))
                                                                    (Prims.of_int (241))
                                                                    (Prims.of_int (28)))))
                                                                    (Obj.magic
                                                                    (Pulse_Checker_Bind.mk_bind
                                                                    g
                                                                    (Pulse_Syntax_Base.Tm_Star
                                                                    (ctxt,
                                                                    (Pulse_Syntax_Base.comp_pre
                                                                    c1))) e1
                                                                    e2_closed
                                                                    c11 c2
                                                                    (Pulse_Syntax_Base.v_as_nv
                                                                    (Pulse_Typing.fresh
                                                                    g))
                                                                    e1_typing1
                                                                    ()
                                                                    e2_typing1
                                                                    () ()))
                                                                    (fun
                                                                    uu___7 ->
                                                                    FStar_Tactics_Effect.lift_div_tac
                                                                    (fun
                                                                    uu___8 ->
                                                                    match uu___7
                                                                    with
                                                                    | 
                                                                    FStar_Pervasives.Mkdtuple3
                                                                    (e, c,
                                                                    e_typing)
                                                                    ->
                                                                    FStar_Pervasives.Mkdtuple3
                                                                    (e, c,
                                                                    e_typing)))))
                                                                    uu___6))))
                                                                    uu___5)))
                                                                    uu___5))))
                                                             uu___3))))))))
                uu___5 uu___4 uu___3 uu___2 uu___1 uu___
type mk_t =
  Pulse_Typing_Env.env ->
    Pulse_Syntax_Base.vprop ->
      unit ->
        ((Pulse_Syntax_Base.st_term, Pulse_Syntax_Base.comp,
           (unit, unit, unit) Pulse_Typing.st_typing)
           FStar_Pervasives.dtuple3 FStar_Pervasives_Native.option,
          unit) FStar_Tactics_Effect.tac_repr
let (elim_one :
  Pulse_Typing_Env.env ->
    Pulse_Syntax_Base.term ->
      Pulse_Syntax_Base.vprop ->
        unit ->
          Pulse_Syntax_Base.st_term ->
            Pulse_Syntax_Base.comp ->
              (unit, unit, unit) Pulse_Typing.st_typing ->
                ((Pulse_Typing_Env.env, Pulse_Syntax_Base.term, unit,
                   (unit, unit, unit, unit) continuation_elaborator)
                   FStar_Pervasives.dtuple4,
                  unit) FStar_Tactics_Effect.tac_repr)
  =
  fun g ->
    fun ctxt ->
      fun p ->
        fun ctxt_p_typing ->
          fun e1 ->
            fun c1 ->
              fun e1_typing ->
                FStar_Tactics_Effect.tac_bind
                  (FStar_Sealed.seal
                     (Obj.magic
                        (FStar_Range.mk_range "Pulse.Checker.Auto.Util.fst"
                           (Prims.of_int (259)) (Prims.of_int (20))
                           (Prims.of_int (259)) (Prims.of_int (57)))))
                  (FStar_Sealed.seal
                     (Obj.magic
                        (FStar_Range.mk_range "Pulse.Checker.Auto.Util.fst"
                           (Prims.of_int (259)) (Prims.of_int (60))
                           (Prims.of_int (273)) (Prims.of_int (34)))))
                  (FStar_Tactics_Effect.lift_div_tac (fun uu___ -> ()))
                  (fun uu___ ->
                     (fun ctxt_typing ->
                        Obj.magic
                          (FStar_Tactics_Effect.tac_bind
                             (FStar_Sealed.seal
                                (Obj.magic
                                   (FStar_Range.mk_range
                                      "Pulse.Checker.Auto.Util.fst"
                                      (Prims.of_int (261))
                                      (Prims.of_int (19))
                                      (Prims.of_int (261))
                                      (Prims.of_int (81)))))
                             (FStar_Sealed.seal
                                (Obj.magic
                                   (FStar_Range.mk_range
                                      "Pulse.Checker.Auto.Util.fst"
                                      (Prims.of_int (259))
                                      (Prims.of_int (60))
                                      (Prims.of_int (273))
                                      (Prims.of_int (34)))))
                             (Obj.magic
                                (continuation_elaborator_with_bind g ctxt c1
                                   e1 e1_typing ()))
                             (fun uu___ ->
                                FStar_Tactics_Effect.lift_div_tac
                                  (fun uu___1 ->
                                     match uu___ with
                                     | Prims.Mkdtuple2 (x, k) ->
                                         FStar_Pervasives.Mkdtuple4
                                           ((Pulse_Typing.extend x
                                               (FStar_Pervasives.Inl
                                                  (Pulse_Syntax_Base.comp_res
                                                     c1)) g),
                                             (Pulse_Syntax_Base.Tm_Star
                                                ((Pulse_Syntax_Naming.open_term_nv
                                                    (Pulse_Syntax_Base.comp_post
                                                       c1)
                                                    (Pulse_Syntax_Base.v_as_nv
                                                       x)), ctxt)), (), k)))))
                       uu___)
let rec (elim_all :
  Pulse_Typing_Env.env ->
    (Pulse_Syntax_Base.vprop ->
       (Prims.bool, unit) FStar_Tactics_Effect.tac_repr)
      ->
      mk_t ->
        Pulse_Syntax_Base.term ->
          unit ->
            ((Prims.bool * (Pulse_Typing_Env.env, Pulse_Syntax_Base.term,
               unit, (unit, unit, unit, unit) continuation_elaborator)
               FStar_Pervasives.dtuple4),
              unit) FStar_Tactics_Effect.tac_repr)
  =
  fun uu___4 ->
    fun uu___3 ->
      fun uu___2 ->
        fun uu___1 ->
          fun uu___ ->
            (fun g ->
               fun f ->
                 fun mk ->
                   fun ctxt ->
                     fun ctxt_typing ->
                       match ctxt with
                       | Pulse_Syntax_Base.Tm_Star (ctxt', p) ->
                           Obj.magic
                             (Obj.repr
                                (FStar_Tactics_Effect.tac_bind
                                   (FStar_Sealed.seal
                                      (Obj.magic
                                         (FStar_Range.mk_range
                                            "Pulse.Checker.Auto.Util.fst"
                                            (Prims.of_int (286))
                                            (Prims.of_int (22))
                                            (Prims.of_int (286))
                                            (Prims.of_int (70)))))
                                   (FStar_Sealed.seal
                                      (Obj.magic
                                         (FStar_Range.mk_range
                                            "Pulse.Checker.Auto.Util.fst"
                                            (Prims.of_int (287))
                                            (Prims.of_int (7))
                                            (Prims.of_int (301))
                                            (Prims.of_int (10)))))
                                   (FStar_Tactics_Effect.lift_div_tac
                                      (fun uu___ -> ()))
                                   (fun uu___ ->
                                      (fun p_typing ->
                                         Obj.magic
                                           (FStar_Tactics_Effect.tac_bind
                                              (FStar_Sealed.seal
                                                 (Obj.magic
                                                    (FStar_Range.mk_range
                                                       "Pulse.Checker.Auto.Util.fst"
                                                       (Prims.of_int (287))
                                                       (Prims.of_int (10))
                                                       (Prims.of_int (287))
                                                       (Prims.of_int (13)))))
                                              (FStar_Sealed.seal
                                                 (Obj.magic
                                                    (FStar_Range.mk_range
                                                       "Pulse.Checker.Auto.Util.fst"
                                                       (Prims.of_int (287))
                                                       (Prims.of_int (7))
                                                       (Prims.of_int (301))
                                                       (Prims.of_int (10)))))
                                              (Obj.magic (f p))
                                              (fun uu___ ->
                                                 (fun uu___ ->
                                                    if uu___
                                                    then
                                                      Obj.magic
                                                        (Obj.repr
                                                           (FStar_Tactics_Effect.tac_bind
                                                              (FStar_Sealed.seal
                                                                 (Obj.magic
                                                                    (
                                                                    FStar_Range.mk_range
                                                                    "Pulse.Checker.Auto.Util.fst"
                                                                    (Prims.of_int (288))
                                                                    (Prims.of_int (18))
                                                                    (Prims.of_int (288))
                                                                    (Prims.of_int (35)))))
                                                              (FStar_Sealed.seal
                                                                 (Obj.magic
                                                                    (
                                                                    FStar_Range.mk_range
                                                                    "Pulse.Checker.Auto.Util.fst"
                                                                    (Prims.of_int (288))
                                                                    (Prims.of_int (12))
                                                                    (Prims.of_int (297))
                                                                    (Prims.of_int (64)))))
                                                              (Obj.magic
                                                                 (mk g p ()))
                                                              (fun uu___1 ->
                                                                 (fun uu___1
                                                                    ->
                                                                    match uu___1
                                                                    with
                                                                    | 
                                                                    FStar_Pervasives_Native.Some
                                                                    (FStar_Pervasives.Mkdtuple3
                                                                    (e1, c1,
                                                                    e1_typing))
                                                                    ->
                                                                    Obj.magic
                                                                    (Obj.repr
                                                                    (FStar_Tactics_Effect.tac_bind
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Auto.Util.fst"
                                                                    (Prims.of_int (291))
                                                                    (Prims.of_int (16))
                                                                    (Prims.of_int (291))
                                                                    (Prims.of_int (60)))))
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Auto.Util.fst"
                                                                    (Prims.of_int (289))
                                                                    (Prims.of_int (45))
                                                                    (Prims.of_int (294))
                                                                    (Prims.of_int (71)))))
                                                                    (Obj.magic
                                                                    (elim_one
                                                                    g ctxt' p
                                                                    () e1 c1
                                                                    e1_typing))
                                                                    (fun
                                                                    uu___2 ->
                                                                    (fun
                                                                    uu___2 ->
                                                                    match uu___2
                                                                    with
                                                                    | 
                                                                    FStar_Pervasives.Mkdtuple4
                                                                    (g',
                                                                    uu___3,
                                                                    ctxt_typing',
                                                                    k) ->
                                                                    Obj.magic
                                                                    (FStar_Tactics_Effect.tac_bind
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Auto.Util.fst"
                                                                    (Prims.of_int (293))
                                                                    (Prims.of_int (16))
                                                                    (Prims.of_int (293))
                                                                    (Prims.of_int (46)))))
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Auto.Util.fst"
                                                                    (Prims.of_int (291))
                                                                    (Prims.of_int (63))
                                                                    (Prims.of_int (294))
                                                                    (Prims.of_int (71)))))
                                                                    (Obj.magic
                                                                    (elim_all
                                                                    g' f mk
                                                                    uu___3 ()))
                                                                    (fun
                                                                    uu___4 ->
                                                                    FStar_Tactics_Effect.lift_div_tac
                                                                    (fun
                                                                    uu___5 ->
                                                                    match uu___4
                                                                    with
                                                                    | 
                                                                    (uu___6,
                                                                    FStar_Pervasives.Mkdtuple4
                                                                    (g'',
                                                                    ctxt'',
                                                                    ctxt_typing'',
                                                                    k')) ->
                                                                    (true,
                                                                    (FStar_Pervasives.Mkdtuple4
                                                                    (g'',
                                                                    ctxt'',
                                                                    (),
                                                                    (k_elab_trans
                                                                    g g' g''
                                                                    (Pulse_Syntax_Base.Tm_Star
                                                                    (ctxt',
                                                                    p))
                                                                    uu___3
                                                                    ctxt'' k
                                                                    k'))))))))
                                                                    uu___2)))
                                                                    | 
                                                                    FStar_Pervasives_Native.None
                                                                    ->
                                                                    Obj.magic
                                                                    (Obj.repr
                                                                    (FStar_Tactics_Effect.lift_div_tac
                                                                    (fun
                                                                    uu___2 ->
                                                                    (false,
                                                                    (FStar_Pervasives.Mkdtuple4
                                                                    (g, ctxt,
                                                                    (),
                                                                    (k_elab_unit
                                                                    g ctxt))))))))
                                                                   uu___1)))
                                                    else
                                                      Obj.magic
                                                        (Obj.repr
                                                           (FStar_Tactics_Effect.lift_div_tac
                                                              (fun uu___2 ->
                                                                 (false,
                                                                   (FStar_Pervasives.Mkdtuple4
                                                                    (g, ctxt,
                                                                    (),
                                                                    (k_elab_unit
                                                                    g ctxt))))))))
                                                   uu___))) uu___)))
                       | uu___ ->
                           Obj.magic
                             (Obj.repr
                                (FStar_Tactics_Effect.lift_div_tac
                                   (fun uu___1 ->
                                      (false,
                                        (FStar_Pervasives.Mkdtuple4
                                           (g, ctxt, (),
                                             (k_elab_unit g ctxt))))))))
              uu___4 uu___3 uu___2 uu___1 uu___
let (add_elims_aux :
  Pulse_Typing_Env.env ->
    Pulse_Syntax_Base.term ->
      (Pulse_Syntax_Base.vprop ->
         (Prims.bool, unit) FStar_Tactics_Effect.tac_repr)
        ->
        mk_t ->
          unit ->
            ((Prims.bool * (Pulse_Typing_Env.env, Pulse_Syntax_Base.term,
               unit, (unit, unit, unit, unit) continuation_elaborator)
               FStar_Pervasives.dtuple4),
              unit) FStar_Tactics_Effect.tac_repr)
  =
  fun g ->
    fun ctxt ->
      fun f ->
        fun mk ->
          fun ctxt_typing ->
            FStar_Tactics_Effect.tac_bind
              (FStar_Sealed.seal
                 (Obj.magic
                    (FStar_Range.mk_range "Pulse.Checker.Auto.Util.fst"
                       (Prims.of_int (315)) (Prims.of_int (40))
                       (Prims.of_int (315)) (Prims.of_int (65)))))
              (FStar_Sealed.seal
                 (Obj.magic
                    (FStar_Range.mk_range "Pulse.Checker.Auto.Util.fst"
                       (Prims.of_int (315)) (Prims.of_int (4))
                       (Prims.of_int (319)) (Prims.of_int (66)))))
              (Obj.magic (canon_right g ctxt () f))
              (fun uu___ ->
                 (fun uu___ ->
                    match uu___ with
                    | FStar_Pervasives.Mkdtuple3 (ctxt', ctxt'_typing, k) ->
                        Obj.magic
                          (FStar_Tactics_Effect.tac_bind
                             (FStar_Sealed.seal
                                (Obj.magic
                                   (FStar_Range.mk_range
                                      "Pulse.Checker.Auto.Util.fst"
                                      (Prims.of_int (317)) (Prims.of_int (9))
                                      (Prims.of_int (317))
                                      (Prims.of_int (35)))))
                             (FStar_Sealed.seal
                                (Obj.magic
                                   (FStar_Range.mk_range
                                      "Pulse.Checker.Auto.Util.fst"
                                      (Prims.of_int (315))
                                      (Prims.of_int (68))
                                      (Prims.of_int (319))
                                      (Prims.of_int (66)))))
                             (Obj.magic (elim_all g f mk ctxt' ()))
                             (fun uu___1 ->
                                FStar_Tactics_Effect.lift_div_tac
                                  (fun uu___2 ->
                                     match uu___1 with
                                     | (progress, FStar_Pervasives.Mkdtuple4
                                        (g', ctxt'', ctxt''_typing, k')) ->
                                         (progress,
                                           (FStar_Pervasives.Mkdtuple4
                                              (g', ctxt'', (),
                                                (k_elab_trans g g g' ctxt
                                                   ctxt' ctxt'' k k'))))))))
                   uu___)
let rec (add_elims :
  Pulse_Typing_Env.env ->
    Pulse_Syntax_Base.term ->
      (Pulse_Syntax_Base.vprop ->
         (Prims.bool, unit) FStar_Tactics_Effect.tac_repr)
        ->
        mk_t ->
          unit ->
            ((Pulse_Typing_Env.env, Pulse_Syntax_Base.term, unit,
               (unit, unit, unit, unit) continuation_elaborator)
               FStar_Pervasives.dtuple4,
              unit) FStar_Tactics_Effect.tac_repr)
  =
  fun g ->
    fun ctxt ->
      fun f ->
        fun mk ->
          fun ctxt_typing ->
            FStar_Tactics_Effect.tac_bind
              (FStar_Sealed.seal
                 (Obj.magic
                    (FStar_Range.mk_range "Pulse.Checker.Auto.Util.fst"
                       (Prims.of_int (329)) (Prims.of_int (25))
                       (Prims.of_int (329)) (Prims.of_int (55)))))
              (FStar_Sealed.seal
                 (Obj.magic
                    (FStar_Range.mk_range "Pulse.Checker.Auto.Util.fst"
                       (Prims.of_int (329)) (Prims.of_int (4))
                       (Prims.of_int (336)) (Prims.of_int (6)))))
              (Obj.magic (add_elims_aux g ctxt f mk ()))
              (fun uu___ ->
                 (fun uu___ ->
                    match uu___ with
                    | (progress, res) ->
                        if Prims.op_Negation progress
                        then
                          Obj.magic
                            (Obj.repr
                               (FStar_Tactics_Effect.lift_div_tac
                                  (fun uu___1 -> res)))
                        else
                          Obj.magic
                            (Obj.repr
                               (FStar_Tactics_Effect.tac_bind
                                  (FStar_Sealed.seal
                                     (Obj.magic
                                        (FStar_Range.mk_range
                                           "Pulse.Checker.Auto.Util.fst"
                                           (Prims.of_int (333))
                                           (Prims.of_int (45))
                                           (Prims.of_int (333))
                                           (Prims.of_int (48)))))
                                  (FStar_Sealed.seal
                                     (Obj.magic
                                        (FStar_Range.mk_range
                                           "Pulse.Checker.Auto.Util.fst"
                                           (Prims.of_int (332))
                                           (Prims.of_int (10))
                                           (Prims.of_int (336))
                                           (Prims.of_int (6)))))
                                  (FStar_Tactics_Effect.lift_div_tac
                                     (fun uu___2 -> res))
                                  (fun uu___2 ->
                                     (fun uu___2 ->
                                        match uu___2 with
                                        | FStar_Pervasives.Mkdtuple4
                                            (g', ctxt', ctxt'_typing, k) ->
                                            Obj.magic
                                              (FStar_Tactics_Effect.tac_bind
                                                 (FStar_Sealed.seal
                                                    (Obj.magic
                                                       (FStar_Range.mk_range
                                                          "Pulse.Checker.Auto.Util.fst"
                                                          (Prims.of_int (334))
                                                          (Prims.of_int (49))
                                                          (Prims.of_int (334))
                                                          (Prims.of_int (76)))))
                                                 (FStar_Sealed.seal
                                                    (Obj.magic
                                                       (FStar_Range.mk_range
                                                          "Pulse.Checker.Auto.Util.fst"
                                                          (Prims.of_int (333))
                                                          (Prims.of_int (51))
                                                          (Prims.of_int (335))
                                                          (Prims.of_int (57)))))
                                                 (Obj.magic
                                                    (add_elims g' ctxt' f mk
                                                       ()))
                                                 (fun uu___3 ->
                                                    FStar_Tactics_Effect.lift_div_tac
                                                      (fun uu___4 ->
                                                         match uu___3 with
                                                         | FStar_Pervasives.Mkdtuple4
                                                             (g'', ctxt'',
                                                              ctxt''_typing,
                                                              k')
                                                             ->
                                                             FStar_Pervasives.Mkdtuple4
                                                               (g'', ctxt'',
                                                                 (),
                                                                 (k_elab_trans
                                                                    g g' g''
                                                                    ctxt
                                                                    ctxt'
                                                                    ctxt'' k
                                                                    k'))))))
                                       uu___2)))) uu___)
type ('g, 'v) vprop_typing = unit
let (ghost_comp :
  Pulse_Syntax_Base.vprop ->
    Pulse_Syntax_Base.vprop -> Pulse_Syntax_Base.comp)
  =
  fun pre ->
    fun post ->
      Pulse_Syntax_Base.C_STGhost
        (Pulse_Syntax_Base.Tm_EmpInames,
          {
            Pulse_Syntax_Base.u = Pulse_Syntax_Pure.u_zero;
            Pulse_Syntax_Base.res = Pulse_Typing.tm_unit;
            Pulse_Syntax_Base.pre = pre;
            Pulse_Syntax_Base.post = post
          })
type 'g prover_state_preamble =
  {
  ctxt: Pulse_Syntax_Base.vprop ;
  ctxt_typing: unit ;
  t: Pulse_Syntax_Base.st_term ;
  c: Pulse_Syntax_Base.comp_st ;
  t_typing: (unit, unit, unit) Pulse_Typing.st_typing }
let (__proj__Mkprover_state_preamble__item__ctxt :
  Pulse_Typing_Env.env ->
    unit prover_state_preamble -> Pulse_Syntax_Base.vprop)
  =
  fun g ->
    fun projectee ->
      match projectee with | { ctxt; ctxt_typing; t; c; t_typing;_} -> ctxt

let (__proj__Mkprover_state_preamble__item__t :
  Pulse_Typing_Env.env ->
    unit prover_state_preamble -> Pulse_Syntax_Base.st_term)
  =
  fun g ->
    fun projectee ->
      match projectee with | { ctxt; ctxt_typing; t; c; t_typing;_} -> t
let (__proj__Mkprover_state_preamble__item__c :
  Pulse_Typing_Env.env ->
    unit prover_state_preamble -> Pulse_Syntax_Base.comp_st)
  =
  fun g ->
    fun projectee ->
      match projectee with | { ctxt; ctxt_typing; t; c; t_typing;_} -> c
let (__proj__Mkprover_state_preamble__item__t_typing :
  Pulse_Typing_Env.env ->
    unit prover_state_preamble -> (unit, unit, unit) Pulse_Typing.st_typing)
  =
  fun g ->
    fun projectee ->
      match projectee with
      | { ctxt; ctxt_typing; t; c; t_typing;_} -> t_typing
type 'g prover_state =
  {
  preamble: unit prover_state_preamble ;
  matched_pre: Pulse_Syntax_Base.term ;
  unmatched_pre: Pulse_Syntax_Base.term Prims.list ;
  remaining_ctxt: Pulse_Syntax_Base.term Prims.list ;
  proof_steps: Pulse_Syntax_Base.st_term ;
  proof_steps_typing: (unit, unit, unit) Pulse_Typing.st_typing ;
  pre_equiv: unit }
let (__proj__Mkprover_state__item__preamble :
  Pulse_Typing_Env.env -> unit prover_state -> unit prover_state_preamble) =
  fun g ->
    fun projectee ->
      match projectee with
      | { preamble; matched_pre; unmatched_pre; remaining_ctxt; proof_steps;
          proof_steps_typing; pre_equiv;_} -> preamble
let (__proj__Mkprover_state__item__matched_pre :
  Pulse_Typing_Env.env -> unit prover_state -> Pulse_Syntax_Base.term) =
  fun g ->
    fun projectee ->
      match projectee with
      | { preamble; matched_pre; unmatched_pre; remaining_ctxt; proof_steps;
          proof_steps_typing; pre_equiv;_} -> matched_pre
let (__proj__Mkprover_state__item__unmatched_pre :
  Pulse_Typing_Env.env ->
    unit prover_state -> Pulse_Syntax_Base.term Prims.list)
  =
  fun g ->
    fun projectee ->
      match projectee with
      | { preamble; matched_pre; unmatched_pre; remaining_ctxt; proof_steps;
          proof_steps_typing; pre_equiv;_} -> unmatched_pre
let (__proj__Mkprover_state__item__remaining_ctxt :
  Pulse_Typing_Env.env ->
    unit prover_state -> Pulse_Syntax_Base.term Prims.list)
  =
  fun g ->
    fun projectee ->
      match projectee with
      | { preamble; matched_pre; unmatched_pre; remaining_ctxt; proof_steps;
          proof_steps_typing; pre_equiv;_} -> remaining_ctxt
let (__proj__Mkprover_state__item__proof_steps :
  Pulse_Typing_Env.env -> unit prover_state -> Pulse_Syntax_Base.st_term) =
  fun g ->
    fun projectee ->
      match projectee with
      | { preamble; matched_pre; unmatched_pre; remaining_ctxt; proof_steps;
          proof_steps_typing; pre_equiv;_} -> proof_steps
let (__proj__Mkprover_state__item__proof_steps_typing :
  Pulse_Typing_Env.env ->
    unit prover_state -> (unit, unit, unit) Pulse_Typing.st_typing)
  =
  fun g ->
    fun projectee ->
      match projectee with
      | { preamble; matched_pre; unmatched_pre; remaining_ctxt; proof_steps;
          proof_steps_typing; pre_equiv;_} -> proof_steps_typing
let (proof_steps_post :
  Pulse_Typing_Env.env -> unit prover_state -> Pulse_Syntax_Base.vprop) =
  fun g ->
    fun p ->
      Pulse_Syntax_Base.Tm_Star
        ((Pulse_Checker_VPropEquiv.list_as_vprop p.remaining_ctxt),
          (p.matched_pre))
let (bind_proof_steps_with :
  Pulse_Typing_Env.env ->
    unit prover_state ->
      Pulse_Syntax_Base.st_term ->
        Pulse_Syntax_Base.comp_st ->
          (unit, unit, unit) Pulse_Typing.st_typing ->
            (Pulse_Syntax_Base.st_term,
              (unit, unit, unit) Pulse_Typing.st_typing) Prims.dtuple2)
  = fun g -> fun p -> fun t -> fun c -> fun t_typing -> Prims.admit ()
type prover_step_t =
  Pulse_Typing_Env.env ->
    unit prover_state ->
      (unit prover_state FStar_Pervasives_Native.option, unit)
        FStar_Tactics_Effect.tac_repr
type 'c intro_comp = unit
type ('g, 'ctxt, 'v) proof_step =
  {
  remaining': Pulse_Syntax_Base.vprop Prims.list ;
  t': Pulse_Syntax_Base.st_term ;
  c': Pulse_Syntax_Base.comp ;
  t'_typing: (unit, unit, unit) Pulse_Typing.st_typing ;
  remaining_equiv: unit }
let (__proj__Mkproof_step__item__remaining' :
  Pulse_Typing_Env.env ->
    Pulse_Syntax_Base.vprop Prims.list ->
      Pulse_Syntax_Base.vprop ->
        (unit, unit, unit) proof_step -> Pulse_Syntax_Base.vprop Prims.list)
  =
  fun g ->
    fun ctxt ->
      fun v ->
        fun projectee ->
          match projectee with
          | { remaining'; t'; c'; t'_typing; remaining_equiv;_} -> remaining'
let (__proj__Mkproof_step__item__t' :
  Pulse_Typing_Env.env ->
    Pulse_Syntax_Base.vprop Prims.list ->
      Pulse_Syntax_Base.vprop ->
        (unit, unit, unit) proof_step -> Pulse_Syntax_Base.st_term)
  =
  fun g ->
    fun ctxt ->
      fun v ->
        fun projectee ->
          match projectee with
          | { remaining'; t'; c'; t'_typing; remaining_equiv;_} -> t'
let (__proj__Mkproof_step__item__c' :
  Pulse_Typing_Env.env ->
    Pulse_Syntax_Base.vprop Prims.list ->
      Pulse_Syntax_Base.vprop ->
        (unit, unit, unit) proof_step -> Pulse_Syntax_Base.comp)
  =
  fun g ->
    fun ctxt ->
      fun v ->
        fun projectee ->
          match projectee with
          | { remaining'; t'; c'; t'_typing; remaining_equiv;_} -> c'
let (__proj__Mkproof_step__item__t'_typing :
  Pulse_Typing_Env.env ->
    Pulse_Syntax_Base.vprop Prims.list ->
      Pulse_Syntax_Base.vprop ->
        (unit, unit, unit) proof_step ->
          (unit, unit, unit) Pulse_Typing.st_typing)
  =
  fun g ->
    fun ctxt ->
      fun v ->
        fun projectee ->
          match projectee with
          | { remaining'; t'; c'; t'_typing; remaining_equiv;_} -> t'_typing
type ('g, 'p) intro_from_unmatched_step =
  {
  v: Pulse_Syntax_Base.vprop ;
  ps: (unit, unit, unit) proof_step ;
  unmatched': Pulse_Syntax_Base.vprop Prims.list ;
  unmatched_equiv: unit }
let (__proj__Mkintro_from_unmatched_step__item__v :
  Pulse_Typing_Env.env ->
    unit prover_state ->
      (unit, unit) intro_from_unmatched_step -> Pulse_Syntax_Base.vprop)
  =
  fun g ->
    fun p ->
      fun projectee ->
        match projectee with | { v; ps; unmatched'; unmatched_equiv;_} -> v
let (__proj__Mkintro_from_unmatched_step__item__ps :
  Pulse_Typing_Env.env ->
    unit prover_state ->
      (unit, unit) intro_from_unmatched_step -> (unit, unit, unit) proof_step)
  =
  fun g ->
    fun p ->
      fun projectee ->
        match projectee with | { v; ps; unmatched'; unmatched_equiv;_} -> ps
let (__proj__Mkintro_from_unmatched_step__item__unmatched' :
  Pulse_Typing_Env.env ->
    unit prover_state ->
      (unit, unit) intro_from_unmatched_step ->
        Pulse_Syntax_Base.vprop Prims.list)
  =
  fun g ->
    fun p ->
      fun projectee ->
        match projectee with
        | { v; ps; unmatched'; unmatched_equiv;_} -> unmatched'
type proof_step_fn =
  Pulse_Typing_Env.env ->
    Pulse_Syntax_Base.term Prims.list ->
      Pulse_Syntax_Base.vprop ->
        unit ->
          unit ->
            ((unit, unit, unit) proof_step FStar_Pervasives_Native.option,
              unit) FStar_Tactics_Effect.tac_repr
type intro_from_unmatched_fn =
  Pulse_Typing_Env.env ->
    unit prover_state ->
      ((unit, unit) intro_from_unmatched_step FStar_Pervasives_Native.option,
        unit) FStar_Tactics_Effect.tac_repr
let (add_frame :
  Pulse_Typing_Env.env ->
    Pulse_Syntax_Base.st_term ->
      Pulse_Syntax_Base.comp_st ->
        (unit, unit, unit) Pulse_Typing.st_typing ->
          Pulse_Syntax_Base.vprop ->
            (Pulse_Syntax_Base.comp,
              (unit, unit, unit) Pulse_Typing.st_typing) Prims.dtuple2)
  = fun g -> fun t -> fun c -> fun d -> fun f -> Prims.admit ()
let (with_pre_post :
  Pulse_Syntax_Base.comp_st ->
    Pulse_Syntax_Base.vprop ->
      Pulse_Syntax_Base.vprop -> Pulse_Syntax_Base.comp_st)
  =
  fun c ->
    fun pre ->
      fun post ->
        match c with
        | Pulse_Syntax_Base.C_ST s ->
            Pulse_Syntax_Base.with_st_comp c
              {
                Pulse_Syntax_Base.u = (s.Pulse_Syntax_Base.u);
                Pulse_Syntax_Base.res = (s.Pulse_Syntax_Base.res);
                Pulse_Syntax_Base.pre = pre;
                Pulse_Syntax_Base.post = post
              }
        | Pulse_Syntax_Base.C_STGhost (uu___, s) ->
            Pulse_Syntax_Base.with_st_comp c
              {
                Pulse_Syntax_Base.u = (s.Pulse_Syntax_Base.u);
                Pulse_Syntax_Base.res = (s.Pulse_Syntax_Base.res);
                Pulse_Syntax_Base.pre = pre;
                Pulse_Syntax_Base.post = post
              }
        | Pulse_Syntax_Base.C_STAtomic (uu___, s) ->
            Pulse_Syntax_Base.with_st_comp c
              {
                Pulse_Syntax_Base.u = (s.Pulse_Syntax_Base.u);
                Pulse_Syntax_Base.res = (s.Pulse_Syntax_Base.res);
                Pulse_Syntax_Base.pre = pre;
                Pulse_Syntax_Base.post = post
              }
let (pre_equiv :
  Pulse_Typing_Env.env ->
    Pulse_Syntax_Base.st_term ->
      Pulse_Syntax_Base.comp_st ->
        (unit, unit, unit) Pulse_Typing.st_typing ->
          Pulse_Syntax_Base.vprop ->
            unit ->
              (Pulse_Syntax_Base.comp,
                (unit, unit, unit) Pulse_Typing.st_typing) Prims.dtuple2)
  = fun g -> fun t -> fun c -> fun d -> fun f -> fun uu___ -> Prims.admit ()
let (pre_post_equiv :
  Pulse_Typing_Env.env ->
    Pulse_Syntax_Base.st_term ->
      Pulse_Syntax_Base.comp_st ->
        (unit, unit, unit) Pulse_Typing.st_typing ->
          Pulse_Syntax_Base.vprop ->
            unit ->
              Pulse_Syntax_Base.vprop ->
                unit ->
                  (Pulse_Syntax_Base.comp_st,
                    (unit, unit, unit) Pulse_Typing.st_typing) Prims.dtuple2)
  =
  fun g ->
    fun t ->
      fun c ->
        fun d ->
          fun pre -> fun uu___ -> fun post -> fun uu___1 -> Prims.admit ()
let (st_typing_weakening :
  Pulse_Typing_Env.env ->
    Pulse_Syntax_Base.st_term ->
      Pulse_Syntax_Base.comp ->
        (unit, unit, unit) Pulse_Typing.st_typing ->
          Pulse_Typing_Env.env -> (unit, unit, unit) Pulse_Typing.st_typing)
  = fun g -> fun t -> fun c -> fun d -> fun g' -> Prims.admit ()
let (apply_proof_step :
  Pulse_Typing_Env.env ->
    unit prover_state ->
      Pulse_Syntax_Base.vprop ->
        (unit, unit, unit) proof_step ->
          (unit prover_state, unit) FStar_Tactics_Effect.tac_repr)
  =
  fun g ->
    fun p ->
      fun v ->
        fun r ->
          FStar_Tactics_Effect.tac_bind
            (FStar_Sealed.seal
               (Obj.magic
                  (FStar_Range.mk_range "Pulse.Checker.Auto.Util.fst"
                     (Prims.of_int (391)) (Prims.of_int (13))
                     (Prims.of_int (391)) (Prims.of_int (28)))))
            (FStar_Sealed.seal
               (Obj.magic
                  (FStar_Range.mk_range "Pulse.Checker.Auto.Util.fst"
                     (Prims.of_int (391)) (Prims.of_int (31))
                     (Prims.of_int (460)) (Prims.of_int (39)))))
            (FStar_Tactics_Effect.lift_div_tac
               (fun uu___ -> (p.preamble).ctxt))
            (fun uu___ ->
               (fun ctxt ->
                  Obj.magic
                    (FStar_Tactics_Effect.tac_bind
                       (FStar_Sealed.seal
                          (Obj.magic
                             (FStar_Range.mk_range
                                "Pulse.Checker.Auto.Util.fst"
                                (Prims.of_int (392)) (Prims.of_int (27))
                                (Prims.of_int (392)) (Prims.of_int (77)))))
                       (FStar_Sealed.seal
                          (Obj.magic
                             (FStar_Range.mk_range
                                "Pulse.Checker.Auto.Util.fst"
                                (Prims.of_int (392)) (Prims.of_int (80))
                                (Prims.of_int (460)) (Prims.of_int (39)))))
                       (FStar_Tactics_Effect.lift_div_tac
                          (fun uu___ ->
                             Pulse_Syntax_Base.Tm_Star
                               ((Pulse_Checker_VPropEquiv.list_as_vprop
                                   r.remaining'), (p.matched_pre))))
                       (fun uu___ ->
                          (fun remaining'_matched ->
                             Obj.magic
                               (FStar_Tactics_Effect.tac_bind
                                  (FStar_Sealed.seal
                                     (Obj.magic
                                        (FStar_Range.mk_range
                                           "Pulse.Checker.Auto.Util.fst"
                                           (Prims.of_int (393))
                                           (Prims.of_int (32))
                                           (Prims.of_int (393))
                                           (Prims.of_int (72)))))
                                  (FStar_Sealed.seal
                                     (Obj.magic
                                        (FStar_Range.mk_range
                                           "Pulse.Checker.Auto.Util.fst"
                                           (Prims.of_int (392))
                                           (Prims.of_int (80))
                                           (Prims.of_int (460))
                                           (Prims.of_int (39)))))
                                  (FStar_Tactics_Effect.lift_div_tac
                                     (fun uu___ ->
                                        add_frame g
                                          (__proj__Mkproof_step__item__t' g
                                             p.remaining_ctxt v r)
                                          (__proj__Mkproof_step__item__c' g
                                             p.remaining_ctxt v r)
                                          r.t'_typing remaining'_matched))
                                  (fun uu___ ->
                                     (fun uu___ ->
                                        match uu___ with
                                        | Prims.Mkdtuple2 (r_c', r_t'_typing)
                                            ->
                                            Obj.magic
                                              (FStar_Tactics_Effect.tac_bind
                                                 (FStar_Sealed.seal
                                                    (Obj.magic
                                                       (FStar_Range.mk_range
                                                          "Pulse.Checker.Auto.Util.fst"
                                                          (Prims.of_int (398))
                                                          (Prims.of_int (4))
                                                          (Prims.of_int (402))
                                                          (Prims.of_int (61)))))
                                                 (FStar_Sealed.seal
                                                    (Obj.magic
                                                       (FStar_Range.mk_range
                                                          "Pulse.Checker.Auto.Util.fst"
                                                          (Prims.of_int (395))
                                                          (Prims.of_int (58))
                                                          (Prims.of_int (460))
                                                          (Prims.of_int (39)))))
                                                 (Obj.magic
                                                    (continuation_elaborator_with_bind
                                                       g
                                                       Pulse_Syntax_Base.Tm_Emp
                                                       (ghost_comp ctxt
                                                          (Pulse_Syntax_Base.Tm_Star
                                                             ((Pulse_Checker_VPropEquiv.list_as_vprop
                                                                 p.remaining_ctxt),
                                                               (p.matched_pre))))
                                                       p.proof_steps
                                                       p.proof_steps_typing
                                                       ()))
                                                 (fun uu___1 ->
                                                    (fun uu___1 ->
                                                       match uu___1 with
                                                       | Prims.Mkdtuple2
                                                           (x,
                                                            bind_continuation_elaborator)
                                                           ->
                                                           Obj.magic
                                                             (FStar_Tactics_Effect.tac_bind
                                                                (FStar_Sealed.seal
                                                                   (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Auto.Util.fst"
                                                                    (Prims.of_int (409))
                                                                    (Prims.of_int (81))
                                                                    (Prims.of_int (409))
                                                                    (Prims.of_int (98)))))
                                                                (FStar_Sealed.seal
                                                                   (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Auto.Util.fst"
                                                                    (Prims.of_int (409))
                                                                    (Prims.of_int (101))
                                                                    (Prims.of_int (460))
                                                                    (Prims.of_int (39)))))
                                                                (FStar_Tactics_Effect.lift_div_tac
                                                                   (fun
                                                                    uu___2 ->
                                                                    ()))
                                                                (fun uu___2
                                                                   ->
                                                                   (fun
                                                                    uu___2 ->
                                                                    Obj.magic
                                                                    (FStar_Tactics_Effect.tac_bind
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Auto.Util.fst"
                                                                    (Prims.of_int (412))
                                                                    (Prims.of_int (80))
                                                                    (Prims.of_int (412))
                                                                    (Prims.of_int (88)))))
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Auto.Util.fst"
                                                                    (Prims.of_int (412))
                                                                    (Prims.of_int (91))
                                                                    (Prims.of_int (460))
                                                                    (Prims.of_int (39)))))
                                                                    (FStar_Tactics_Effect.lift_div_tac
                                                                    (fun
                                                                    uu___3 ->
                                                                    ()))
                                                                    (fun
                                                                    uu___3 ->
                                                                    (fun d ->
                                                                    Obj.magic
                                                                    (FStar_Tactics_Effect.tac_bind
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Auto.Util.fst"
                                                                    (Prims.of_int (414))
                                                                    (Prims.of_int (32))
                                                                    (Prims.of_int (416))
                                                                    (Prims.of_int (5)))))
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Auto.Util.fst"
                                                                    (Prims.of_int (412))
                                                                    (Prims.of_int (91))
                                                                    (Prims.of_int (460))
                                                                    (Prims.of_int (39)))))
                                                                    (FStar_Tactics_Effect.lift_div_tac
                                                                    (fun
                                                                    uu___3 ->
                                                                    pre_equiv
                                                                    g
                                                                    (__proj__Mkproof_step__item__t'
                                                                    g
                                                                    p.remaining_ctxt
                                                                    v r) r_c'
                                                                    r_t'_typing
                                                                    (Pulse_Syntax_Base.Tm_Star
                                                                    ((Pulse_Syntax_Base.Tm_Star
                                                                    ((Pulse_Checker_VPropEquiv.list_as_vprop
                                                                    p.remaining_ctxt),
                                                                    (p.matched_pre))),
                                                                    Pulse_Syntax_Base.Tm_Emp))
                                                                    ()))
                                                                    (fun
                                                                    uu___3 ->
                                                                    (fun
                                                                    uu___3 ->
                                                                    match uu___3
                                                                    with
                                                                    | 
                                                                    Prims.Mkdtuple2
                                                                    (r_c'1,
                                                                    r_t'_typing1)
                                                                    ->
                                                                    Obj.magic
                                                                    (FStar_Tactics_Effect.tac_bind
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Auto.Util.fst"
                                                                    (Prims.of_int (419))
                                                                    (Prims.of_int (20))
                                                                    (Prims.of_int (419))
                                                                    (Prims.of_int (78)))))
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Auto.Util.fst"
                                                                    (Prims.of_int (419))
                                                                    (Prims.of_int (81))
                                                                    (Prims.of_int (460))
                                                                    (Prims.of_int (39)))))
                                                                    (FStar_Tactics_Effect.lift_div_tac
                                                                    (fun
                                                                    uu___4 ->
                                                                    st_typing_weakening
                                                                    g
                                                                    (__proj__Mkproof_step__item__t'
                                                                    g
                                                                    p.remaining_ctxt
                                                                    v r)
                                                                    r_c'1
                                                                    r_t'_typing1
                                                                    (Pulse_Typing.extend
                                                                    x
                                                                    (FStar_Pervasives.Inl
                                                                    Pulse_Typing.tm_unit)
                                                                    g)))
                                                                    (fun
                                                                    uu___4 ->
                                                                    (fun
                                                                    r_t'_typing2
                                                                    ->
                                                                    Obj.magic
                                                                    (FStar_Tactics_Effect.tac_bind
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Auto.Util.fst"
                                                                    (Prims.of_int (421))
                                                                    (Prims.of_int (18))
                                                                    (Prims.of_int (428))
                                                                    (Prims.of_int (3)))))
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Auto.Util.fst"
                                                                    (Prims.of_int (430))
                                                                    (Prims.of_int (27))
                                                                    (Prims.of_int (460))
                                                                    (Prims.of_int (39)))))
                                                                    (FStar_Tactics_Effect.lift_div_tac
                                                                    (fun
                                                                    uu___4 ->
                                                                    FStar_Pervasives_Native.Some
                                                                    {
                                                                    Pulse_Checker_Common.g
                                                                    = g;
                                                                    Pulse_Checker_Common.ret_ty
                                                                    =
                                                                    Pulse_Typing.tm_unit;
                                                                    Pulse_Checker_Common.u
                                                                    =
                                                                    Pulse_Syntax_Pure.u_zero;
                                                                    Pulse_Checker_Common.ty_typing
                                                                    = ();
                                                                    Pulse_Checker_Common.post
                                                                    =
                                                                    (Pulse_Syntax_Base.comp_post
                                                                    r_c'1);
                                                                    Pulse_Checker_Common.post_typing
                                                                    = ()
                                                                    }))
                                                                    (fun
                                                                    uu___4 ->
                                                                    (fun
                                                                    post_hint
                                                                    ->
                                                                    Obj.magic
                                                                    (FStar_Tactics_Effect.tac_bind
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Auto.Util.fst"
                                                                    (Prims.of_int (431))
                                                                    (Prims.of_int (43))
                                                                    (Prims.of_int (432))
                                                                    (Prims.of_int (34)))))
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Auto.Util.fst"
                                                                    (Prims.of_int (430))
                                                                    (Prims.of_int (27))
                                                                    (Prims.of_int (460))
                                                                    (Prims.of_int (39)))))
                                                                    (Obj.magic
                                                                    (bind_continuation_elaborator
                                                                    post_hint
                                                                    (FStar_Pervasives.Mkdtuple3
                                                                    ((r.t'),
                                                                    r_c'1,
                                                                    r_t'_typing2))))
                                                                    (fun
                                                                    uu___4 ->
                                                                    FStar_Tactics_Effect.lift_div_tac
                                                                    (fun
                                                                    uu___5 ->
                                                                    match uu___4
                                                                    with
                                                                    | 
                                                                    FStar_Pervasives.Mkdtuple3
                                                                    (steps,
                                                                    steps_c,
                                                                    steps_typing)
                                                                    ->
                                                                    (match 
                                                                    pre_post_equiv
                                                                    g steps
                                                                    steps_c
                                                                    steps_typing
                                                                    ctxt ()
                                                                    (Pulse_Syntax_Base.Tm_Star
                                                                    ((Pulse_Checker_VPropEquiv.list_as_vprop
                                                                    (v ::
                                                                    (r.remaining'))),
                                                                    (p.matched_pre)))
                                                                    ()
                                                                    with
                                                                    | 
                                                                    Prims.Mkdtuple2
                                                                    (steps_c1,
                                                                    steps_typing1)
                                                                    ->
                                                                    {
                                                                    preamble
                                                                    =
                                                                    (p.preamble);
                                                                    matched_pre
                                                                    =
                                                                    (p.matched_pre);
                                                                    unmatched_pre
                                                                    =
                                                                    (p.unmatched_pre);
                                                                    remaining_ctxt
                                                                    = (v ::
                                                                    (r.remaining'));
                                                                    proof_steps
                                                                    = steps;
                                                                    proof_steps_typing
                                                                    =
                                                                    steps_typing1;
                                                                    pre_equiv
                                                                    = ()
                                                                    })))))
                                                                    uu___4)))
                                                                    uu___4)))
                                                                    uu___3)))
                                                                    uu___3)))
                                                                    uu___2)))
                                                      uu___1))) uu___)))
                            uu___))) uu___)
let (apply_intro_from_unmatched_step :
  Pulse_Typing_Env.env ->
    unit prover_state ->
      (unit, unit) intro_from_unmatched_step ->
        (unit prover_state, unit) FStar_Tactics_Effect.tac_repr)
  =
  fun g ->
    fun p ->
      fun r ->
        FStar_Tactics_Effect.tac_bind
          (FStar_Sealed.seal
             (Obj.magic
                (FStar_Range.mk_range "Pulse.Checker.Auto.Util.fst"
                   (Prims.of_int (473)) (Prims.of_int (13))
                   (Prims.of_int (473)) (Prims.of_int (28)))))
          (FStar_Sealed.seal
             (Obj.magic
                (FStar_Range.mk_range "Pulse.Checker.Auto.Util.fst"
                   (Prims.of_int (473)) (Prims.of_int (31))
                   (Prims.of_int (497)) (Prims.of_int (20)))))
          (FStar_Tactics_Effect.lift_div_tac (fun uu___ -> (p.preamble).ctxt))
          (fun uu___ ->
             (fun ctxt ->
                Obj.magic
                  (FStar_Tactics_Effect.tac_bind
                     (FStar_Sealed.seal
                        (Obj.magic
                           (FStar_Range.mk_range
                              "Pulse.Checker.Auto.Util.fst"
                              (Prims.of_int (474)) (Prims.of_int (10))
                              (Prims.of_int (474)) (Prims.of_int (37)))))
                     (FStar_Sealed.seal
                        (Obj.magic
                           (FStar_Range.mk_range
                              "Pulse.Checker.Auto.Util.fst"
                              (Prims.of_int (492)) (Prims.of_int (4))
                              (Prims.of_int (497)) (Prims.of_int (18)))))
                     (Obj.magic (apply_proof_step g p r.v r.ps))
                     (fun p1 ->
                        FStar_Tactics_Effect.lift_div_tac
                          (fun uu___ ->
                             {
                               preamble = (p1.preamble);
                               matched_pre =
                                 (Pulse_Syntax_Base.Tm_Star
                                    ((p1.matched_pre), (r.v)));
                               unmatched_pre = (r.unmatched');
                               remaining_ctxt = ((r.ps).remaining');
                               proof_steps = (p1.proof_steps);
                               proof_steps_typing = (Prims.magic ());
                               pre_equiv = ()
                             })))) uu___)