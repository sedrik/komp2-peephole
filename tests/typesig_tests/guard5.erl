%%%-------------------------------------------------------------------
%%% File    : guard5.erl
%%% Author  : Tobias Lindahl <tobiasl@csd.uu.se>
%%% Description : 
%%%
%%% Created : 18 May 2005 by Tobias Lindahl <tobiasl@csd.uu.se>
%%%-------------------------------------------------------------------
-module(guard5).

-export([is_atom/1, is_bool/1]).

is_atom(X) ->
  true = is_atom(X).

is_bool(X) ->
  false = is_boolean(X).
