%%%-------------------------------------------------------------------
%%% File    : case7.erl
%%% Author  : Tobias Lindahl <tobiasl@it.uu.se>
%%% Description : 
%%%
%%% Created : 24 Jan 2005 by Tobias Lindahl <tobiasl@it.uu.se>
%%%-------------------------------------------------------------------
-module(case7).

-export([t/0, t/1]).

t() ->
  case t(foo) of
    {X, bar} -> {ok, X};
    baz -> error
  end.

t(foo) -> {1, bar}.
  
      
