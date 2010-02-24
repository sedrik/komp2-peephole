%%%-------------------------------------------------------------------
%%% File    : is_funct2.erl
%%% Author  : Tobias Lindahl <tobiasl@csd.uu.se>
%%% Description : 
%%%
%%% Created : 29 Nov 2005 by Tobias Lindahl <tobiasl@csd.uu.se>
%%%-------------------------------------------------------------------
-module(is_funct2).

-export([t1/2, t2/2, t3/1, t4/1]).

t1(F, A) when is_function(F, A) ->
  {F, A}.

t2(F, 2 = A) when is_function(F, A) ->
  {F, A}.

t3(A) ->
  F = fun foo/3,
  case A of
    1 when is_function(F, A) -> {error, F};
    3 when is_function(F, A) -> {ok, F}
  end.

foo(A, B, C) ->
  A + B + C.

t4(A) ->
  F = fun(B, C) -> A + B + C end,
  case A of
    3 when is_function(F, A) -> {error, F};
    2 when is_function(F, A) -> {ok, F}
  end.
