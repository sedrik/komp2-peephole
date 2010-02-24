%%%-------------------------------------------------------------------
%%% File    : merged_const.erl
%%% Author  : Tobias Lindahl <tobiasl@fan.it.uu.se>
%%% Description : This tests the correct merging of constants in the constant
%%%               table. 
%%%
%%% Created : 18 May 2004 by Tobias Lindahl <tobiasl@fan.it.uu.se>
%%%-------------------------------------------------------------------
-module(merged_const).

-export([test/0, compile/1]).

test()->
  A = {'', 1.0000},
  B = {'', 1},
  match(A, B).

match(A, A) ->
  error;
match(_A, _B) ->
  ok.

compile(Opts) ->
  hipe:c(?MODULE, Opts).

