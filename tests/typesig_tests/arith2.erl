%%%-------------------------------------------------------------------
%%% File    : arith2.erl
%%% Author  : Tobias Lindahl <tobiasl@it.uu.se>
%%% Description : 
%%%
%%% Created : 18 Mar 2005 by Tobias Lindahl <tobiasl@it.uu.se>
%%%-------------------------------------------------------------------
-module(arith2).

-export([add/1, sub/1, mult/1]).

add(X) ->
  two(X + 1).

sub(X) ->
  zero(X - 1).

mult(X) ->
  two(X * 2).

zero(0) ->
  ok.

two(2) ->
  ok.
  
