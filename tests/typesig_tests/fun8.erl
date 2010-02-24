-module(fun8).
-export([t/0]).

t() ->
  F = m:f(),
  t(F).

t(F) ->
  case F(1) of
    1 -> ok
  end.

