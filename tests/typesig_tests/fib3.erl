%%-------------------------------------------------------------------
%% File    : fib3.erl
%% Author  : Kostis Sagonas <kostis@it.uu.se>
%% Description : Computes Fibonacci numbers using a closed formula
%%
%% Created : 25 Mar 2006 by Kostis Sagonas <kostis@it.uu.se>
%%-------------------------------------------------------------------
-module(fib3).
-export([fib/1]).
-import(math, [pow/2, sqrt/1]).

fib(N) when is_integer(N) ->
  trunc((1/sqrt(5)) * (pow(((1+sqrt(5))/2),N) - pow(((1-sqrt(5))/2),N))).
