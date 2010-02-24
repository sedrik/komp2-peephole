%%%-------------------------------------------------------------------
%%% File    : catch1.erl
%%% Author  : Tobias Lindahl <tobiasl@it.uu.se>
%%% Description : 
%%%
%%% Created : 24 Jan 2005 by Tobias Lindahl <tobiasl@it.uu.se>
%%%-------------------------------------------------------------------
-module(catch1).
-export([t1/1, t2/2]).

t1(X) ->
  catch X + 1.

t2(X, Y) when is_atom(X), is_integer(Y) ->
  {catch add_one(X), catch add_one(Y)}.

%% Check that the arguments to add_one/1 is propagated.
add_one(X) ->
  X + 1.
