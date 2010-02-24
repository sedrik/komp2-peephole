%%%-------------------------------------------------------------------
%%% File    : case3.erl
%%% Author  : Tobias Lindahl <tobiasl@it.uu.se>
%%% Description : 
%%%
%%% Created : 17 Dec 2004 by Tobias Lindahl <tobiasl@it.uu.se>
%%%-------------------------------------------------------------------
-module(case3).
-export([t/2]).

t(X, Y) ->
  case X of
    1 -> Y + 1;
    2 -> list_to_atom(Y)
  end.
