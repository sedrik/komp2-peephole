%%%-------------------------------------------------------------------
%%% File    : fail1.erl
%%% Author  : Miguel Jimenez <milingo83@gmail.com>
%%% Description : Wrong contract specifications
%%%
%%% Created : 30 May 2007
%%%-------------------------------------------------------------------
-module(fail1).
-export([f1/1, f2/2]).

-spec(fac/1::((integer(), integer()) -> integer())). 
-spec(f1/2::((integer()) -> integer())). 
-spec(f2/1::((integer()) -> integer())). 


fac(0) -> 1;
fac(N) -> N * fac(N-1).

f1(X) ->
    fac(X).

f2(_X, _Y) ->
    fac(4).

