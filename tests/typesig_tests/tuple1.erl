%%%-------------------------------------------------------------------
%%% File    : tuple1.erl
%%% Author  : Tobias Lindahl <tobiasl@it.uu.se>
%%% Description : 
%%%
%%% Created : 11 Aug 2004 by Tobias Lindahl <tobiasl@it.uu.se>
%%%-------------------------------------------------------------------
-module(tuple1).
-export([t/0, t/1]).

t() ->
  t_local(1).

t_local(X) ->
  {X + 41}.

t(X) ->
  {X + 41}.
