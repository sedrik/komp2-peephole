%%%-------------------------------------------------------------------
%%% File    : receive2.erl
%%% Author  : Kostis Sagonas <kostis@it.uu.se>
%%% Description : A weird program to exercise the type analyzer.
%%%
%%% Created : 27 Jan 2005 by Kostis Sagonas <kostis@it.uu.se>
%%%-------------------------------------------------------------------
-module(receive2).
-export([t/1]).

t(Arg) ->
  receive
    {foo, X} = Arg when is_integer(X) -> {int, X};
    Y = Arg when is_float(Y) -> {float, Y}
  end.
