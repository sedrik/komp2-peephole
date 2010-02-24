%%%-------------------------------------------------------------------
%%% File    : catch_unary_plus.erl
%%% Author  : Tobias Lindahl <tobiasl@csd.uu.se>
%%% Description : Unary plus used to be the identity function, 
%%%               but this is not true anymore.
%%%
%%% Created : 13 Nov 2005 by Tobias Lindahl <tobiasl@csd.uu.se>
%%%-------------------------------------------------------------------
-module(catch_unary_plus).

-export([test/0,compile/1]).

test() ->  
  {'EXIT', {badarith, _}} = (catch foo(gazonk)),
  1 = foo(1),
  ok.

foo(X) ->
  +(X).


compile(Flags) ->
    hipe:c(?MODULE,Flags).
