%%%-------------------------------------------------------------------
%%% File    : fun9.erl
%%% Author  : Tobias Lindahl <tobiasl@csd.uu.se>
%%% Description : The analysis had problems with functions that could have 
%%%               more than one arity.
%%%
%%% Created : 23 Oct 2006 by Tobias Lindahl <tobiasl@csd.uu.se>
%%%-------------------------------------------------------------------
-module(fun9).

-export([t/2]).

t(Fun, [Arg1]) -> {Fun(Arg1), Fun};
t(Fun, [Arg1, Arg2]) -> {Fun(Arg1, Arg2), Fun}.
  
      
  
