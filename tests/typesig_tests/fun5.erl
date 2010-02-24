%%%-------------------------------------------------------------------
%%% File    : fun5.erl
%%% Author  : Tobias Lindahl <tobiasl@csd.uu.se>
%%% Description : Tests bound/free variables in funs.
%%%
%%% Created :  3 Jan 2006 by Tobias Lindahl <tobiasl@csd.uu.se>
%%%-------------------------------------------------------------------

-module(fun5).

-export([t/1]).

t(X) ->
  foo(X).

foo(X) when is_integer(X) ->
  X = 2,
  F = fun(Z) ->
	  X + Z
      end,
  F(X).


