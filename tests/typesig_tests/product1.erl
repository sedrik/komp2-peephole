%%%-------------------------------------------------------------------
%%% File    : product1.erl
%%% Author  : Tobias Lindahl <tobiasl@csd.uu.se>
%%% Description : Exposes a bug in unifying products in typesig.
%%%
%%% Created : 16 Dec 2005 by Tobias Lindahl <tobiasl@csd.uu.se>
%%%-------------------------------------------------------------------
-module(product1).

-export([t1/1]).
-export([t2/1]).

t1(X) ->
  {A, B} =
    if X < 10 -> {X, X};
       true   -> {X, X}
    end,
  {A = 2, B}.

t2(X) ->
  A = {X, {X, 1}},
  case A of
    {1, {Y, 1}} -> Y
  end.
      
