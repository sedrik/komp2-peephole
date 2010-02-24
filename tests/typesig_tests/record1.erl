%%%-------------------------------------------------------------------
%%% File    : record1.erl
%%% Author  : Tobias Lindahl <tobiasl@csd.uu.se>
%%% Description : 
%%%
%%% Created : 28 Jun 2005 by Tobias Lindahl <tobiasl@csd.uu.se>
%%%-------------------------------------------------------------------
-module(record1).

-export([t1/1, t2/1, t3/1, t4/0]).

-record(foo, {bar, baz}).

-compile(strict_record_test).


t1(R) when is_record(R, foo) ->
  R.

t2(X = #foo{bar=1}) ->
  X.
  
t3(X) ->
  case {X#foo.bar, X#foo.baz} of
    {1, 2} -> X;
    {Y, Y} when Y =:= 3 -> X
  end.
      
t4() ->
  t1({foo, bar}).
