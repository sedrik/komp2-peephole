%% -*- erlang-indent-level: 2 -*-
%%====================================================================
%% Date: 08/16/06 13:09
%% From: Martin Bjorklund <mbj@tail-f.com>
%% Subject: Compiler bug
%% 
%% I found this compiler bug in R10B-10 and R11B-0.
%%
%% Function -just_compile_me/0-fun-2-/1 refers to undefined label 18
%% ./bjorklund_R11compiler_bug.erl:none: internal error in beam_clean;
%% crash reason: {{case_clause,{'EXIT',{undefined_label,18}}},
%%                [{compile,'-select_passes/2-anonymous-2-',2},
%%                 {compile,'-internal_comp/4-anonymous-1-',2},
%%                 {compile,fold_comp,3},
%%                 {compile,internal_comp,4},
%%                 {compile,internal,3}]}
%%====================================================================

-module(bjorklund_R11compiler_bug).
-export([test/0, compile/1, just_compile_me/0]).

-compile([no_copt]).	%% shut off warnings about unused term constructions

test() -> ok.

just_compile_me() ->
  G = fun() -> ok end,
  try
    G()	%% fun() -> ok end
  after
    fun({A, B}) -> A + B end
  end.

compile(Opts) ->
  hipe:c(?MODULE, Opts).

