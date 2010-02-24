%%%-------------------------------------------------------------------
%%% File    : tuple2.erl
%%% Author  : Tobias Lindahl <tobiasl@it.uu.se>
%%% Description : Excercise the unification of tagged tuples.
%%%
%%% Created : 21 Feb 2005 by Tobias Lindahl <tobiasl@it.uu.se>
%%%-------------------------------------------------------------------
-module(tuple2).

-export([t1/1,t2/1]).

t1(X) ->    
  {_, baz} = X,
  gazonk(X).  

t2(X) ->
  A = 
    case X of
      1 -> foo;
      2 -> bar
    end,
  B = 
    case X  of
      1 -> a;
      2 -> b
    end,
  {gazonk({A, B}), {A, B}}.

gazonk({foo, _}) -> foo;
gazonk({bar, _}) -> bar.	  		   
