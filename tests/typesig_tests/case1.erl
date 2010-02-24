%%%-------------------------------------------------------------------
%%% File    : case1.erl
%%% Author  : Tobias Lindahl <tobiasl@it.uu.se>
%%% Description : 
%%%
%%% Created : 11 Aug 2004 by Tobias Lindahl <tobiasl@it.uu.se>
%%%-------------------------------------------------------------------
-module(case1).
-export([t/0, t/1]).

t() ->
  t_local(1).

t_local(X) ->
  case {1, X} of
    {1, 2} ->
      ok;
    {_, 3} -> X;
    Foo -> Foo
  end.

t(X) ->
  case {1, X} of
    {1, 2} ->
      ok;
    {_, 3} -> X;
    Foo -> Foo
  end.
