%%%-------------------------------------------------------------------
%%% File    : bin8.erl
%%% Author  : Tobias Lindahl <tobiasl@csd.uu.se>
%%% Description : 
%%%
%%% Created : 27 Sep 2007 by Tobias Lindahl <tobiasl@csd.uu.se>
%%%-------------------------------------------------------------------
-module(bin8).

-export([t1/0]).

t1() ->
  match1(<<1,2,3>>).

match1(<<Bin:4/binary>>) ->
  error;
match1(<<Bin:3/binary>>) ->
  ok.
