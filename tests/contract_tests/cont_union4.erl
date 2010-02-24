%%%-------------------------------------------------------------------
%%% File    : cont_union2.erl
%%% Author  : Miguel Jimenez <milingo83@gmail.com>
%%% Description : Union of subset (not disjointed) contracts
%%%
%%% Created : 30 May 2007
%%%-------------------------------------------------------------------
-module(cont_union4).
-export([t1/0, t2/0]).

-spec(t/1 :: (([number()]) -> [atom()]) ; 
             (([atom()]) -> [integer()])).


t(P) -> 
  lists:map(
    fun(X) -> case X*X of
		1 -> 2;
		_ -> foo
	      end
    end, 
    P).

t1() ->
    t([3.0,4.0,5.0]).

t2() ->
    t([1,1,1]).


