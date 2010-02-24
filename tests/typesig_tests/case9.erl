%%%-------------------------------------------------------------------
%%% File    : case9.erl
%%% Author  : Tobias Lindahl <tobiasl@it.uu.se>
%%% Description : Excercise the andalso and orelse behaviour.
%%%
%%% Created : 28 Jan 2005 by Tobias Lindahl <tobiasl@it.uu.se>
%%%-------------------------------------------------------------------
-module(case9).
-export([t/0, t3/1, t4/1]).

t() ->
  case t2() andalso (t2() =:= t2()) of
    true -> ok;
    false -> error
  end.

t2() ->
  true.

t3(X) ->
  case t2() orelse X of
    true -> ok;
    false -> error
  end.
      
t4(X) ->
  case X orelse t2() of
    true -> ok;
    false -> error
  end.
