%%%-------------------------------------------------------------------
%%% File    : receive1.erl
%%% Author  : Tobias Lindahl <tobiasl@it.uu.se>
%%% Description : 
%%%
%%% Created : 26 Jan 2005 by Tobias Lindahl <tobiasl@it.uu.se>
%%%-------------------------------------------------------------------
-module(receive1).
-export([t/0]).

t() ->
  receive
    {foo, X} when is_integer(X) -> {int, X};
    Y when is_float(Y) -> {float, Y}
  after
    100 -> ok
  end.
