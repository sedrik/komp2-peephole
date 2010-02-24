%%%-------------------------------------------------------------------
%%% File    : lists3.erl
%%% Author  : Miguel Jimenez <milingo83@gmail.com>
%%% Description : More on lists
%%%
%%% Created : 30 May 2007
%%%-------------------------------------------------------------------
-module(lists3).
-export([map2/2, all2/2, all2_call/0, foldl2_call/2]).

-spec (map2/2 :: ((((X) -> Y), [X]) -> [Y])).
-spec (all2/2 :: ((((X) -> Y), [X]) -> Y)).
-spec (foldl2/3 :: ((((X,Y) -> Y), Y, [X]) -> Y)).

inc(X) ->
    X + 1.

map2(F, [H|T]) ->
    [F(H)|map2(F, T)];
map2(F, []) when is_function(F, 1) -> [].

map3() ->
    map2(fun inc/1, [foo]).

all2(F, X) ->
    lists:all(F, X).

all2_call() ->
    F = fun(A) -> if A / 2 > 8 ->  true;
		     true -> false
		  end
	end,  
    all2(F, [3.9,4.9,5.6,7.7]).

foldl2(F, Accu, X) ->
    lists:foldl(F, Accu, X).
    
foldl2_call(List, A) ->
    Fun = fun(H, Accu) ->
		  foo
	  end,
    foldl2(Fun, A, List).

foldl2_call2() ->
    foldl2_call([3,4,5], 8.6).

