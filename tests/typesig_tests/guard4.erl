-module(guard4).
-export([test/0]).

test() ->
  f(42).

f(N) when is_integer(N) ->
  N + 1;
f(L) when is_list(L) ->
  size(L);	%% erroneous use which should not influence result
f(L) when is_binary(L) ->
  size(L).
