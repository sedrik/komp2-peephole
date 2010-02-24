%%%-------------------------------------------------------------------
%%% File    : fp_ebb.erl
%%% Author  : Tobias Lindahl <tobiasl@csd.uu.se>
%%% Description : Test the construction of overlapping fp extended 
%%%               basic blocks where BEAM has constructed one and 
%%%               hipe_icode_fp constructs the other one.
%%%
%%% Created : 18 Aug 2003 by Tobias Lindahl <tobias@it.uu.se>
%%%-------------------------------------------------------------------

-module(fp_ebb).
-export([test/0,compile/1]).

test()->
  1.0 = foo(2*math:pi()),
  1.0 = bar(2*math:pi()),
  ok.

foo(X) ->
  X / (2 * math:pi()).

bar(X) ->
  F = float_two(),
  case F < 3.0 of
    true -> (X * F) / ((2 * F) * math:pi());
    false -> weird
  end.

float_two() ->
  2.0.

compile(O) ->
  hipe:c(?MODULE,O).
