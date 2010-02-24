%%%-------------------------------------------------------------------
%%% File    : receive4.erl
%%% Author  : Tobias Lindahl <tobiasl@it.uu.se>
%%% Description : Receives used as sleeps
%%%
%%% Created : 16 Mar 2005 by Tobias Lindahl <tobiasl@it.uu.se>
%%%-------------------------------------------------------------------
-module(receive4).

-export([t/0]).

t() ->
  receive after 1 -> ok end.

