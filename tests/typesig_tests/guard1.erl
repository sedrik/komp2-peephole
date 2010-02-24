%%%-------------------------------------------------------------------
%%% File    : guard1.erl
%%% Author  : Tobias Lindahl <tobiasl@it.uu.se>
%%% Description : 
%%%
%%% Created :  3 Jan 2005 by Tobias Lindahl <tobiasl@it.uu.se>
%%%-------------------------------------------------------------------
-module(guard1).
-export([t/1]).

t(X) when is_atom(X) -> atom;
t(X) when is_integer(X) -> int.
