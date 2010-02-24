%%%-------------------------------------------------------------------
%%% File    : bs_double_size.erl
%%% Author  : Tobias Lindahl <tobiasl@csd.uu.se>
%%% Description : 
%%%
%%% Created : 16 Dec 2004 by Tobias Lindahl <tobiasl@csd.uu.se>
%%%-------------------------------------------------------------------
-module(bs_double_size).

-export([test/0, compile/1]).


test() ->
  t(<<0,1,0,0,0>>),
  ok.

t(T) ->
  <<S:16,
   _:S/binary,
   _:S/binary,
   _/binary>> = T.

compile(Opts) ->
  hipe:c(?MODULE, Opts).
