%%%-------------------------------------------------------------------
%%% File    : orelse_test.erl
%%% Author  : Tobias Lindahl <tobiasl@csd.uu.se>
%%% Description : Redundant test in BEAM-code will generate type warning.
%%%
%%% Created :  1 Sep 2004 by Tobias Lindahl <tobiasl@csd.uu.se>
%%%-------------------------------------------------------------------
-module(orelse_test).

-export([test/0, compile/1]).

test() ->
  test(true, true, true),
  ok.

test(A, B, C) ->
  A andalso B orelse C.

compile(Flags) ->
  hipe:c(?MODULE, Flags).
