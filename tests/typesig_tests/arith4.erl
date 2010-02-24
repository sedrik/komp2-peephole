%%%-------------------------------------------------------------------
%%% File    : bitops1.erl
%%% Author  : Tobias Lindahl <tobiasl@csd.uu.se>
%%% Description : Triggered a bug with '-'/1.
%%%
%%% Created : 10 Jan 2007 by Tobias Lindahl <tobiasl@csd.uu.se>
%%%-------------------------------------------------------------------
-module(arith4).

-export([t1/1]).

t1(N) ->
  Bits = foo(),
  (N =< ((1 bsl (Bits - 1)) - 1)) and (N >= -(1 bsl (Bits - 1))).

foo() ->
  case foo:bar() of
    1 -> 4;
    2 -> 8
  end.
