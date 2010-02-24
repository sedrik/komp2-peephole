%% -*- erlang-indent-level: 2 -*-
%%
%% Makes sure that pattern matching expressions involving ++ work OK.
%% The third expression caused a problem in the Erlang shell of R11B-5.
%% It worked OK in both interpreted and compiled code.

-module(fun04).
-export([test/0, compile/1]).

test() ->
  ok = (fun("X" ++ _) -> ok end)("X"),
  ok = (fun([$X | _]) -> ok end)("X"),
  ok = (fun([$X] ++ _) -> ok end)("X"),
  ok.

compile(Opts) ->
  hipe:c(?MODULE, Opts).

