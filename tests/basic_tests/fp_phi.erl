%%%-------------------------------------------------------------------
%%% File    : fp_phi.erl
%%% Author  : Tobias Lindahl <tobiasl@fan.it.uu.se>
%%% Description : 
%%%
%%% Created : 15 Apr 2008 by Tobias Lindahl <tobiasl@fan.it.uu.se>
%%%-------------------------------------------------------------------

-module(fp_phi).
-export([test/0,compile/1]).

test() ->
  10 = foo(10, 100),
  undefined = foo(1.1e302, 0.000000001),
  ok.

foo(A, B) ->
  case catch A / B of
    {'EXIT', _Reason} -> undefined;
    _ -> round(100 * (A / B))
  end.

compile(O) ->
  hipe:c(?MODULE,O).
