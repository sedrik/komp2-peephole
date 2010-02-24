%%%-------------------------------------------------------------------
%%% File    : list8.erl
%%% Author  : Tobias Lindahl <tobiasl@csd.uu.se>
%%% Description : 
%%%
%%% Created : 18 Dec 2006 by Tobias Lindahl <tobiasl@csd.uu.se>
%%%-------------------------------------------------------------------
-module(list8).

-export([t1/2, t2/2, t3/2, t4/2]).

t1(X, Y) ->
  case X ++ Y of
    [] -> ok
  end.

t2(X, Y) ->
  case X ++ Y of
    [foo] -> ok
  end.

t3(X, Y) ->
  case X ++ Y of
    [foo] -> ok;
    [bar, baz] -> ok
  end.

t4(X, Y) ->
  case X ++ Y of
    [foo|bar] -> ok
  end.

