%%%-------------------------------------------------------------------
%%% File    : dataflow1.erl
%%% Author  : Miguel Jimenez <milingo83@gmail.com>
%%% Description : Dataflow analysis
%%%
%%% Created : 30 May 2007
%%%-------------------------------------------------------------------
-module(dataflow1).
-export([f3/0, f4/0]).

-spec (add/1 :: ((Primero :: X) -> X)).
-spec (f3/0 :: (() -> byte())).
-spec (f4/0 :: (() -> byte())).

add(X) ->
    X + 1.

f3() ->
    add(200).

f4() ->
    add(300).
