%%%-------------------------------------------------------------------
%%% File    : recursive3.erl
%%% Author  : Tobias Lindahl <tobiasl@csd.uu.se>
%%% Description : 
%%%
%%% Created : 12 Mar 2007 by Tobias Lindahl <tobiasl@csd.uu.se>
%%%-------------------------------------------------------------------
-module(recursive3).

-export([t1/1, t2/1]).

t1(A) when is_atom(A) ->
  t1(A).

t2(A) when is_atom(A) ->
  t3(A).

t3(A) ->
  t4(A).

t4(A) ->
  t3(A).
