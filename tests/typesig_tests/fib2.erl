%%-------------------------------------------------------------------
%% File    : fib2.erl
%% Author  : Kostis Sagonas <kostis@it.uu.se>
%% Description : Mutual recursive Fibonacci functions to test
%%		 inferrence of number types.
%%
%% Created : 1 Feb 2005 by Kostis Sagonas <kostis@it.uu.se>
%%-------------------------------------------------------------------
-module(fib2).
-export([test/0]).

test() ->
  R1 = [fib_int(X) || X <- [0,1,2,3,4,5,6,7,8,9,10]],
  R2 = [fib_float(X) || X <- [0.0,1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0,9.0,10.0]],
  R1 == R2.

%% integer() -> integer()

fib_int(0) ->
  1;
fib_int(1) ->
  1;
fib_int(N) ->
  fib_float(float(N-1)) + fib_int(N-2).

%% float() -> integer()

fib_float(F) when is_float(F) and (-0.01 < F) and (F < 0.01) ->
  1;
fib_float(F) when is_float(F) and  (0.99 < F) and (F < 1.01) ->
  1;
fib_float(F) when is_float(F) ->
  fib_int(trunc(F-1)) + fib_float(F-2).

