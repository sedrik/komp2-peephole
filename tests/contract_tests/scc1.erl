%%%-------------------------------------------------------------------
%%% File    : scc1.erl
%%% Author  : Miguel Jimenez <milingo83@gmail.com>
%%% Description : Little strongly connected component test
%%%
%%% Created : 30 May 2007
%%%-------------------------------------------------------------------
-module(scc1).
-export([mini_scc/2]).

%% Success types without contracts
%% scc1:mini_scc1/1 :: ((possibly_improper_list()) -> bool())
%% scc1:mini_scc/2 :: ((_,bool()) -> bool())

-spec (mini_scc/2 :: (([integer()], bool()) -> atom() | [integer()])).
-spec (mini_scc1/1 :: ((any()) -> bool())).


mini_scc(X,true) ->
    mini_scc1(X);

mini_scc(_X,false) ->
    false.

mini_scc1([2|T]) ->
    mini_scc(T,true);

mini_scc1([_|T]) ->
    mini_scc(T,false);

mini_scc1([]) ->
    true.
