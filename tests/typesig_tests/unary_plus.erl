%%-------------------------------------------------------------------
%% File        : unary_plus.erl
%% Author      : Tobias Lindahl <tobiasl@it.uu.se>
%% Description : Checks that the '+'/1 functions works as in R10B.
%% Created     : 11 Aug 2005 by Tobias Lindahl <tobiasl@it.uu.se>
%%-------------------------------------------------------------------
-module(unary_plus).
-export([t/1]).
-export([error/0]).

t() ->
  t(3.14) + t(42).

t(X) ->
  +(X).

error() ->
  +(gazonk).
