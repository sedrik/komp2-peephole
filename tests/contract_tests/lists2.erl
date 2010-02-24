%%%-------------------------------------------------------------------
%%% File    : lists1.erl
%%% Author  : Miguel Jimenez <milingo83@gmail.com>
%%% Description : Some list functions examples. Problembs with different 
%%%               types of lists (list(), nonempty_list()...)
%%%
%%% Created : 30 May 2007
%%%-------------------------------------------------------------------
-module(lists2).
-export([nth/2, t0/0, t1/1, t2/1]).

-spec (nth/2 :: ((non_neg_integer(), [any()]) -> any())).
-spec (merge/1 :: (([[any()]]) -> any())).

nth(1, [H|_]) -> H;
nth(N, [_|T]) when N > 1 ->
    nth(N - 1, T).

merge(L) ->
    lists:merge(L).

t0() ->
    merge([7,8,9]).

t1(N) ->
    nth(N, []).

t2(N) ->
    nth(N, [3,9,4|7]).

