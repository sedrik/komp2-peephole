%%%-------------------------------------------------------------------
%%% File    : case8.erl
%%% Author  : Tobias Lindahl <tobiasl@it.uu.se>
%%% Description : 
%%%
%%% Created : 24 Jan 2005 by Tobias Lindahl <tobiasl@it.uu.se>
%%%-------------------------------------------------------------------
-module(case8).

-export([t/1]).

t(X) when is_integer(X) ->
  case t2() of
    X -> error;
    _ -> ok
  end.

t2()->
  4.3.
