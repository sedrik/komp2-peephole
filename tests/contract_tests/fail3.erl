%%%-------------------------------------------------------------------
%%% File    : fail3.erl
%%% Author  : Miguel Jimenez <milingo83@gmail.com>
%%% Description : Type mismatching
%%%
%%% Created : 30 May 2007
%%%-------------------------------------------------------------------
-module(fail3).
-export([f1/0, f2/0, fac/1]).

-spec (fac/1 :: ((byte()) -> integer())).


fac(0) -> 1;
fac(N) -> N * fac(N-1).

%% Will succeed
f1() ->
    fac(255).

%% Will fail
f2() ->
    fac(256).
