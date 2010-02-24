%%%-------------------------------------------------------------------
%%% File    : param1.erl
%%% Author  : Miguel Jimenez <milingo83@gmail.com>
%%% Description : Basic parametric polymorphism test
%%%
%%% Created : 30 May 2007
%%%-------------------------------------------------------------------
-module(param1).
-export([mystery/1]).

-spec (mystery/2 :: ((A, [A]) -> [A]) when is_subtype(A, byte())).
%% Without contract:
%% mystery/1 :: (([any()]) -> [any()])
%% mystery/2 :: ((integer(),[any()]) -> [any(),...])


mystery([]) ->
  [];
mystery([H|T]) ->
  mystery(H, T).

mystery(I, Acc) when is_integer(I)  ->
  lists:reverse([I | Acc]).
