%%%-------------------------------------------------------------------
%%% File    : unsafe_add_bug.erl
%%% Author  : Tobias Lindahl <tobiasl@csd.uu.se>
%%% Description : 
%%%
%%% Created : 15 Feb 2007 by Tobias Lindahl <tobiasl@csd.uu.se>
%%%-------------------------------------------------------------------
-module(unsafe_add_bug).

-export([test/0,compile/1]).

compile(O) ->
  hipe:c(?MODULE,O).

test() ->
  {ok, ok} = {test(16#7ffffff,0),test(16#7ffffff,16#7ffffff)},
  ok.

test(X,Y) ->
  case ok of
    V when X+Y > 12 -> V;
    _ -> bad
  end.
