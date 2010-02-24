%%% -*- erlang-indent-level: 2 -*-
%%% $Id: unsafe_bsl_bug.erl,v 1.1 2006/12/10 22:43:42 mikpe Exp $
%%% In October 2006 the HiPE compiler acquired more type-driven
%%% optimisations of arithmetic operations. One of these, the
%%% transformation of bsl to a pure fixnum bsl fixnum -> fixnum
%%% version (unsafe_bsl), was incorrectly performed even when the
%%% result wouldn't be a fixnum. The error occurred for all backends,
%%% but the only place known to break was hipe_arm:imm_to_am1/2.
%%% Some immediates got broken on ARM, causing segmentation faults
%%% in compiler_tests when HiPE recompiled itself.
-module(unsafe_bsl_bug).
-export([test/0, compile/1]).

test() ->
  check(test_cases()).

compile(Opts) ->
  hipe:c(?MODULE, Opts).

test_cases() ->
  [{16#FF, {16#FF,0}},
   {16#F000000F, {16#FF,2}}].

check([]) -> ok;
check([{X,Y}|Rest]) ->
  case imm_to_am1(X) of
    Y -> check(Rest);
    _ -> 'hipe_broke_bsl'
  end.

imm_to_am1(Imm) -> imm_to_am1(Imm band 16#FFFFFFFF, 16).
imm_to_am1(Imm, RotCnt) ->
  if Imm >= 0, Imm =< 255 -> {Imm, RotCnt band 15};
     true ->
      NewRotCnt = RotCnt - 1,
      if NewRotCnt =:= 0 -> []; % full circle, no joy
	 true ->
	  NewImm = (Imm bsr 2) bor ((Imm band 3) bsl 30),
	  imm_to_am1(NewImm, NewRotCnt)
      end
  end.      
