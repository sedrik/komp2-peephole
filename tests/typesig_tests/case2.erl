%%%-------------------------------------------------------------------
%%% File    : case2.erl
%%% Author  : Tobias Lindahl <tobiasl@it.uu.se>
%%% Description : 
%%%
%%% Created : 11 Aug 2004 by Tobias Lindahl <tobiasl@it.uu.se>
%%%-------------------------------------------------------------------
-module(case2).
-export([t/0]).

t() ->
  t(1).

t(X) ->
  case {X} of
    A -> 
      case A of
	1 -> ok
      end
  end.
