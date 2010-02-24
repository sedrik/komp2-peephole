%%%-------------------------------------------------------------------
%%% File    : func_head1.erl
%%% Author  : Tobias Lindahl <tobiasl@it.uu.se>
%%% Description : 
%%%
%%% Created : 11 Aug 2004 by Tobias Lindahl <tobiasl@it.uu.se>
%%%-------------------------------------------------------------------
-module(func_head1).

-export([t/0]).

t() ->
  t(1).

t(1) ->
  ok;
t(2) ->
  error1;
t(3) ->
  error2.
    


