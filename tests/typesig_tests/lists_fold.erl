-module(lists_fold).
-compile(export_all).

fold_sum() ->
  F = fun (X, Sum) when is_integer(Sum) -> X + Sum end,
  lists:foldl(F, 0, [1,2,3]).

%% The fact that F fails should play no role in this case
fold_nil() ->
  F = fun (X, Sum) when is_atom(Sum) -> X + Sum end,
  lists:foldl(F, 0, []).

fold_none() ->
  F = fun (X, Sum) when is_atom(Sum) -> X + Sum end,
  lists:foldl(F, 0, [a,b,c]).

%% Here the type of the accumulator plays no role, but the type system
%% is not strong enough to discover this fact, so we over-approximate
fold_ignore_acc_nonempty() ->
  F = fun (X, _) when is_integer(X) -> X + 1 end,
  lists:foldl(F, gazonk, [1,2,3]).

%% ... here obviously the accumulator cannot be ignored
fold_ignore_acc_nil() ->
  F = fun (X, _) when is_integer(X) -> X + 1 end,
  lists:foldl(F, gazonk, []).

%% ... while here we have to be conservative and include both types
fold_ignore_acc_list(List) ->
  F = fun (X, _) when is_integer(X) -> X + 1 end,
  lists:foldl(F, gazonk, List).
