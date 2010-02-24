%% -*- erlang-indent-level: 2 -*-

%% Program which was submitted as a bug report on Feb 19th 2004 by
%% "Jozsef Berces (PR/ECZ)" <jozsef.berces@ericsson.com>.
%%
%% As it turned out, the type propagator thought that the call
%%           lists:map({string,strip}, LL)
%% would crash anyway (its type was undefined), so it was removing
%% all code below it causing a
%%   {{badmatch,{["A","B","C"],0}},[{tuple_as_fun_bug,smartconcat,0}]}
%% error message.
%%
%% Currently, this program compiles fine, although it should really be
%% rejected as illegal by the HiPE compiler.

-module(tuple_as_fun_bug).
-export([test/0, compile/1]).

test() ->
  ["A","B","C"] = smartconcat(),
  ok.

smartconcat() ->
  LL = ["H'A"," H'B"," H'C"],
  %% using a tuple as a fun caused havoc in the type analyzer
  LL2 = lists:map({string,strip}, LL),
  HexFormat = fun(X, Acc) -> {string:substr(X,3), Acc} end,
  {LL3,_Ret} = lists:mapfoldl(HexFormat, 0, LL2),
  lists:sublist(LL3, 42).

%% The following function will need modification once the type
%% analyzer is modified to reject programs with tuples used as funs.

compile(Opts) ->
  %% insist that type analysis takes place
  hipe:c(?MODULE,[icode_type|Opts]).

