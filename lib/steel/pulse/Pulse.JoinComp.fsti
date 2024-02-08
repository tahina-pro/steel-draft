(*
   Copyright 2023 Microsoft Research

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*)

module Pulse.JoinComp

open Pulse.Syntax
open Pulse.Typing

effect TacS (a:Type) (pre : Type0) (post : (_:a{pre}) -> Type0) =
  Tactics.TacH a (requires (fun _ -> pre))
                 (ensures (fun _ r -> pre /\ (
                                      match r with
                                      | Tactics.Result.Success r _ -> post r
                                      | _ -> True))) // does not guarantee anything on failure

val join_comps
  (g_then:env)
  (e_then:st_term)
  (c_then:comp_st)
  (e_then_typing:st_typing g_then e_then c_then)
  (g_else:env)
  (e_else:st_term)
  (c_else:comp_st)
  (e_else_typing:st_typing g_else e_else c_else)
  (post:post_hint_t)
: TacS (c:comp_st &
        st_typing g_then e_then c &
        st_typing g_else e_else c)
    (requires
      comp_post_matches_hint c_then (Some post) /\
      comp_post_matches_hint c_else (Some post) /\
      comp_pre c_then == comp_pre c_else)
    (ensures fun (| c, _, _ |) ->
        st_comp_of_comp c == st_comp_of_comp c_then /\
        comp_post_matches_hint c (Some post))
