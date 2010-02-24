-module(int_mult1).
-export([f/2, g/2]).

-define(REM2(A, B), ((A) band ((B)-1))).

f(A, B) ->
  4 * ?REM2(A, B).

g(A, B) when is_integer(A * B) ->
  A + B.
