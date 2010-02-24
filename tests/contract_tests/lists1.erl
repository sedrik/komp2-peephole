%%%-------------------------------------------------------------------
%%% File    : lists1.erl
%%% Author  : Miguel Jimenez <milingo83@gmail.com>
%%% Description : Some list functions examples. Problembs with different 
%%%               types of lists (list(), nonempty_list()...)
%%%
%%% Created : 30 May 2007
%%%-------------------------------------------------------------------
-module(lists1).
-export([nth/2, subtract/2, append/1, append/2, t/0, t1/0, t2/1, t3/0]).

-spec (append/2 :: (([A], [A]) -> [A])).
-spec (append/1 :: (([A]) -> A)).
-spec (subtract/2 :: (([A], [A]) -> [A])).
-spec (nth/2 :: ((non_neg_integer(), [A]) -> A)).


nth(1, [H|_]) -> H;
nth(N, [_|T]) when N > 1 ->
    nth(N - 1, T).


subtract(L1, L2) -> L1 -- L2.


append(L1, L2) -> L1 ++ L2.

append([E]) -> E;
append([H|T]) -> H ++ append(T);
append([]) -> [].

%% list() and nonempty_list() unification
t() ->
    append([5, 7]).

%% 6 and 7 are not subtypes but they are raised to integer() to be unified
t1() ->
    append([6],[7]).

t2(X) ->
    append(X,[foo]).

t3() ->
    append([],5.4).


