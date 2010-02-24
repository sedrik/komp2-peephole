%%-------------------------------------------------------------------
%% File    : arith1.erl
%% Author  : Kostis Sagonas <kostis@it.uu.se>
%% Description : Tests 'backwards' propagation of arithmetic constraints.
%%
%% Created : 31 Jan 2005 by Kostis Sagonas <kostis@it.uu.se>
%%-------------------------------------------------------------------
-module(arith1).
-export([next_random/1, next_random2/1, mystery/1]).

%% Types for the first two functions should be correctly inferred by
%% having built-in knowledge about the arithmetic operations.
next_random(N) ->
  (N * 1713) rem 1001.

next_random2(N) -> 
  R = N * 1713,
  {R rem 1001, R}.

%% Inferring precise types (integer() rather than number()) for these
%% two functions is quite hard though.
mystery(X)->
  Y = num(X),
  Y div 2.

num(X) ->
  X * 2.
