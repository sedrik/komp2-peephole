%%%-------------------------------------------------------------------
%%% File    : exit.erl
%%% Author  : Tobias Lindahl <tobiasl@csd.uu.se>
%%% Description : 
%%%
%%% Created :  4 Jan 2006 by Tobias Lindahl <tobiasl@csd.uu.se>
%%%-------------------------------------------------------------------
-module(exit).

-export([t1/0, t2/1]).

t1() ->
  exit(error).

t2(Pid) ->
  exit(Pid, kill).
