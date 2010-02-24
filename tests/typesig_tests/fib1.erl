%%%-------------------------------------------------------------------
%%% File    : fib1.erl
%%% Author  : Tobias Lindahl <tobiasl@it.uu.se>
%%% Description : Fibonacci numbers
%%%
%%% Created : 17 Feb 2003 by Tobias Lindahl <tobiasl@it.uu.se>
%%%-------------------------------------------------------------------
-module(fib1).
-export([fib/1]).

fib(0)->
  1;
fib(1)->
  1;
fib(N)->
  fib(N-1) + fib(N-2).
