%% -*- erlang-indent-level: 2 -*-
%%====================================================================
%% Date: 09/13/06 20:34
%% From: Tim Rath <rath64@verizon.net>
%% Subject: Compiler bug not quite fixed
%% 
%% I saw a compiler bug posted to the list by Martin Bjorklund that
%% appeared to be exactly the problem I'm seeing, and then noticed
%% that this was fixed in R11B-1. Unfortunately, though R11B-1 appears
%% to fix the code submitted by Martin, it does not fix my case.
%%
%% Function -just_compile_me/0-fun-2-/1 refers to undefined label 13
%% ./rath_R11compiler_bug.erl:none: internal error in beam_clean;
%% crash reason: {{case_clause,{'EXIT',{undefined_label,13}}},
%%                [{compile,'-select_passes/2-anonymous-2-',2},
%%                 {compile,'-internal_comp/4-anonymous-1-',2},
%%                 {compile,fold_comp,3},
%%                 {compile,internal_comp,4},
%%                 {compile,internal,3}]}
%%====================================================================

-module(rath_R11compiler_bug).
-export([test/0, compile/1, just_compile_me/0]).

-compile([no_copt]).	%% shut off warnings about unused term constructions

test() -> ok.

just_compile_me() ->
  A = {6},
  try
    io:fwrite("")
  after
    fun () ->
      fun () -> {_} = A end
    end
  end.

compile(Opts0) ->
  case proplists:get_bool(core, Opts0) of
    true ->
	test:note(?MODULE, "disabling compilation from core - BUG"),
	Opts = [{core,false}|Opts0];
    false ->
	Opts = Opts0
  end,
  hipe:c(?MODULE, Opts).

