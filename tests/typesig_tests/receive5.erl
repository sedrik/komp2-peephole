%%%-------------------------------------------------------------------
%%% File    : receive5.erl
%%% Author  : Tobias Lindahl <tobiasl@csd.uu.se>
%%% Description : Provokes a bug when there is a failure in timeouts.
%%%
%%% Created : 17 Jan 2006 by Tobias Lindahl <tobiasl@csd.uu.se>
%%%-------------------------------------------------------------------
-module(receive5).

-export([call/1]).

call(Timeout) ->
  receive 
    {?MODULE, Reply} -> Reply
  after Timeout ->
      exit({timeout, ?MODULE})
  end.
