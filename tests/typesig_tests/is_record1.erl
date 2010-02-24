%%%-------------------------------------------------------------------
%%% File    : is_record1.erl
%%% Author  : Tobias Lindahl <tobiasl@csd.uu.se>
%%% Description : 
%%%
%%% Created :  6 Oct 2006 by Tobias Lindahl <tobiasl@csd.uu.se>
%%%-------------------------------------------------------------------
-module(is_record1).

-export([t1/1, t2/2, t3/2, t4/3, t5/3, t6/1,t7/1]).

-record(foo, {bar}).

t1(X) when is_record(X, foo) ->
  ok.

t2(X, Y) ->
  is_record(X, Y).

t3(X, Y) ->
  true = is_record(X, Y).

t4(X, Y, Z) ->
  is_record(X, Y, Z).

t5(X, Y, Z) ->
  true = is_record(X, Y, Z).

t6(X) when is_record(X, bar, 5) ->
  X.

t7(X) ->
  case X of
    true -> t8({foo, bar});
    false -> t8({bar, foo})
  end.

t8(X) when is_record(X, foo) ->
  X.

