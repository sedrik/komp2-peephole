%%%-------------------------------------------------------------------
%%% File    : tuple1.erl
%%% Author  : Tobias Lindahl <tobiasl@it.uu.se>
%%% Description : 
%%%
%%% Created : 11 Aug 2004 by Tobias Lindahl <tobiasl@it.uu.se>
%%%-------------------------------------------------------------------
-module(tuple1).
-export([t/0, t/1]).

%% We insert a (useless) tuple set.
-spec (t/0 :: (() -> {42} | {67})).
%% We insert a (useless) union in the tuple.
-spec (t_local/1 :: ((1) -> {42 | 67})).
-spec (t/1 :: ((integer()) -> {integer()})).

t() ->
  t_local(1).

t_local(X) ->
  {X + 41}.

t(X) ->
  {X + 41}.
