%%%-------------------------------------------------------------------
%%% File    : param4.erl
%%% Author  : Tobias Lindahl <tobiasl@csd.uu.se>
%%% Description : 
%%%
%%% Created : 31 May 2007 by Tobias Lindahl <tobiasl@csd.uu.se>
%%%-------------------------------------------------------------------
-module(param5).

-export([t1/2, t2/2, t3/2, t4/2, t5/2]).


-spec(t1/2 :: ((A, A)-> [A]) when is_subtype(B,any())).
-spec(t2/2 :: ((A, A)-> [A]) when is_subtype(A,any())).
-spec(t3/2 :: ((A, A)-> [A]) when is_subtype(A,integer())).
-spec(t4/2 :: ((A, A)-> [A]) when is_subtype(A,atom())).
-spec(t5/2 :: ((A, A)-> [A]) when is_subtype(A,pid())).


t1(A = foo, B = 1) ->
  [A, B].

t2(X, Y) -> t1(X, Y).

t3(X, Y) -> t1(X, Y).

t4(X, Y) -> t1(X, Y).

t5(X, Y) -> t1(X, Y).
