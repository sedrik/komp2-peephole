%%%-------------------------------------------------------------------
%%% File    : case4.erl
%%% Author  : Tobias Lindahl <tobiasl@it.uu.se>
%%% Description : 
%%%
%%% Created :  4 Jan 2005 by Tobias Lindahl <tobiasl@it.uu.se>
%%%-------------------------------------------------------------------
-module(case4).
-export([t1/1, t2/1]).

t1(X) ->
  case X of
    {foo, Z} -> Z +1
  end,
  case X of
    {hello, Y} ->
      Y+1
  end.

t2(X) ->
  case X of
    {foo, Z} -> Z +1;
    {hello, 1} -> 2
  end,
  case X of
    {hello, Y} ->
      Y+1
  end.
