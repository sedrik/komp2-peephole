%%%-------------------------------------------------------------------
%%% File    : cons.erl
%%% Author  : Tobias Lindahl <tobiasl@it.uu.se>
%%% Description : 
%%%
%%% Created : 11 Aug 2004 by Tobias Lindahl <tobiasl@it.uu.se>
%%%-------------------------------------------------------------------
-module(cons).
-export([t/0]).

t() ->
  t(1).

t(X) ->
  [X].




