%%%-------------------------------------------------------------------
%%% File    : sequence.erl
%%% Author  : Tobias Lindahl <tobiasl@it.uu.se>
%%% Description : 
%%%
%%% Created : 15 Dec 2004 by Tobias Lindahl <tobiasl@it.uu.se>
%%%-------------------------------------------------------------------
-module(sequence).
-export([t1/0, t2/1, t3/1]).

t1() ->
  add(100, 5, 5),
  add(200, 10, 10).

t2(X) when is_atom(X) ->
  add(X, 7, 7),
  t1().

t3(X) ->
  bad_add(X, X),
  t1().

add(0, _, _) -> ok;
add(Iter, A, B) ->
  A + B,
  add(Iter-1, A, B).

bad_add(X, Y) when is_atom(X) ->
  X + Y.
