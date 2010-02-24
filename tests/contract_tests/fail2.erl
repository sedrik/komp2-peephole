%%%-------------------------------------------------------------------
%%% File    : fail1.erl
%%% Author  : Miguel Jimenez <milingo83@gmail.com>
%%% Description : Wrong contract specifications. Type mismatching
%%%
%%% Created : 30 May 2007
%%%-------------------------------------------------------------------
-module(fail2).
-export([f1/1, f2/2]).

-spec(fac/1::((atom()) -> integer())).
-spec(f1/1::((integer()) -> bool())). 
-spec(f2/2::((integer()) -> 5)). 


fac(0) -> 1;
fac(N) -> N * fac(N-1).

f1(X) ->
    fac(X).

f2(_X, _Y) ->
    fac(4).

