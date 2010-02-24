%% This program is supposed to check inference of integer ranges.
%% Currently, they are not handled by typesig.  They should be.

-module(range1).
-export([l/1]).

l([]) ->
  ok;
l([N | L]) when is_integer(N), 0 =< N, N =< 255 ->
  l(L).

