%%%-------------------------------------------------------------------
%%% File    : call1.erl
%%% Author  : Miguel Jimenez <milingo83@gmail.com>
%%% Description : 
%%%
%%% Created : 31 May 2007
%%%-------------------------------------------------------------------
-module(call1).
-export([f1/0, f2/0, f3/0]).

%% Contract for fac in fail3.erl:
%% -spec (fac/1 :: ((byte()) -> integer())).

%% Contract for mul in param2.erl:
%% -spec (mul/1 :: ((integer()) -> byte())).


%% Will succeed
f1() ->
    fail3:fac(255).

%% Will fail
f2() ->
    fail3:fac(256).

%% The same signature as mul/1 in param2.erl
f3() ->
    param2:mul(300).

  






