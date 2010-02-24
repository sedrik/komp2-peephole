%%
%% Small test program used to show various properties of the type
%% inference we employ to Karol Ostrovski
%%

-module(karol).
-export([expand_args_any/1, three/0]).

expand_args_any(0) ->
  [];
expand_args_any(X) when is_atom(X) ->
  X = karol,
  ["_"];
expand_args_any(1) ->
  ["_"];
expand_args_any(X) ->
  ["_"|expand_args_any(X-1)].

%% Function for which type analysis produces something relatively weird...
three() ->
  1 + two().

two() ->
  2.
