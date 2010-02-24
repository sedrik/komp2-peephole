%%%-------------------------------------------------------------------
%%% File    : fun6.erl
%%% Author  : Tobias Lindahl <tobiasl@csd.uu.se>
%%% Description : 
%%%
%%% Created : 25 Jan 2006 by Tobias Lindahl <tobiasl@csd.uu.se>
%%%-------------------------------------------------------------------
-module(fun6).

-export([t/1]).

%% This should be (atom())->((_)->none()) since the anonymous fun
%% should be affected by its environment, but the parent function
%% should not be affected by what happens inside the child function.

t(X) when is_atom(X) ->
  fun(Y) -> X + Y end.


