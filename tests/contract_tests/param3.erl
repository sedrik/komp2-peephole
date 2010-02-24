%%%-------------------------------------------------------------------
%%% File    : param3.erl
%%% Author  : Tobias Lindahl <tobiasl@csd.uu.se>
%%% Description : 
%%%
%%% Created : 31 May 2007 by Tobias Lindahl <tobiasl@csd.uu.se>
%%%-------------------------------------------------------------------
-module(param3).

-export([t1/2, t11/2, t2/2, t3/1, t4/0, t5/0]).

-spec(t1/2 :: ((A, A) -> [A])).
-spec(t11/2 :: ((A, A) -> [A])).
%%-spec(t2/2 :: ((A, A)-> [A])).
-spec(t2/2 :: ((1, byte()) -> [byte()])).
%%-spec(t3/1 :: ((A)-> A)).
-spec(t3/1 :: ((1) -> 2)).
-spec(t4/0 :: (() -> 2)).
-spec(t5/0 :: (() -> 2)).


t1(A = foo, B = 1) ->
  [A, B].

t11(A = 3, B = 1) ->
  [A, B].

t2(A = 1, B) when is_integer(B) ->
  [A, B].

t3(X) when X =:= 1 ->
  X + 1.

t4() ->
  t3(1).

t5() ->
  t3(5).

