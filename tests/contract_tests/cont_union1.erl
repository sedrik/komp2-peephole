%%%-------------------------------------------------------------------
%%% File    : cont_union11.erl
%%% Author  : Miguel Jimenez <milingo83@gmail.com>
%%% Description : Checks the union of contracts
%%%
%%% Created : 30 May 2007
%%%-------------------------------------------------------------------

-module(cont_union1).
-export([numbers2/0]).

%% numbers2/0 and numbers3/0 would return number() without the contract
-spec(numbers/1 :: ((integer()) -> integer()) ; 
                   ((float()) -> float())).


numbers(X) when is_integer(X) ->
  X + 4;
numbers(X) when is_float(X) ->
  X + 4.0.

numbers2() ->
  numbers(5.0).

numbers3() ->
  numbers(5).
