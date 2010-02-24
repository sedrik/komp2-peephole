%%%-------------------------------------------------------------------
%%% File    : arith1.erl
%%% Author  : Miguel Jimenez <milingo83@gmail.com>
%%% Description : 
%%%
%%% Created : 30 May 2007
%%%-------------------------------------------------------------------
-module(arith1).
-export([add/1, sub/1]).

-include("types.hrl").

-spec(add/1::((1) -> new2())). 
-spec(sub/1::((integer()) -> 3)). 



add(X) ->
  two(X + 1).

two(2) ->
  2.
  
sub(X) ->
  zero(X - 1).

zero(0) ->
  0.

  






