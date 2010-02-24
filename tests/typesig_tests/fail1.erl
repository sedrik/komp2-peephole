%%%-------------------------------------------------------------------
%%% File    : fail1.erl
%%% Author  : Tobias Lindahl <tobiasl@it.uu.se>
%%% Description : Checks what's happening when clauses or functions fail.
%%%
%%% Created : 12 Jan 2005 by Tobias Lindahl <tobiasl@it.uu.se>
%%%-------------------------------------------------------------------
-module(fail1).
-export([t1/2, t2/1]).

t1(X, Y) ->
  case X of
    1 -> 3=4, Y + 1;
    2 -> list_to_atom(Y)
  end.

t2(X) ->
  t3(X),
  ok.

t3(X) when is_list(42) ->
  ok.

