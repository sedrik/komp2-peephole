%%%-------------------------------------------------------------------
%%% File    : try2.erl
%%% Author  : Tobias Lindahl <tobiasl@it.uu.se>
%%% Description : 
%%%
%%% Created : 17 Mar 2005 by Tobias Lindahl <tobiasl@it.uu.se>
%%%-------------------------------------------------------------------
-module(try2).

-export([t1/1, t2/1]).

t1(A) ->
  try foo(A) of
      {ok, Q} -> {ok, Q}
  catch
    Class:Reason when A =:= 1-> error
  after
    bar()
  end.

foo(1) ->
  {ok, 1}.

bar() ->
  ok.

t2(A) ->
  try foo(A) of
      {ok, Q} -> {ok, Q}
  catch
    Class:Reason when A =:= 1 -> error
  after
    foo(A+1)
  end.
