%%%-------------------------------------------------------------------
%%% File    : guard2.erl
%%% Author  : Tobias Lindahl <tobiasl@it.uu.se>
%%% Description : 
%%%
%%% Created : 12 Jan 2005 by Tobias Lindahl <tobiasl@it.uu.se>
%%%-------------------------------------------------------------------
-module(guard2).
-export([t1/1, t2/1, t3/1, t4/1, t5/2, t6/1, t7/1, t8/1]).

t1(X) when is_atom(X); length(X) > 1 -> ok.

t2(X) when is_atom(X), length(X) > 1 -> ok.

t3(X) when X =:= foo, is_atom(X) -> ok.

t4(X) when X =:= foo; X =:= bar -> ok.

t5(X, Y) when X =:= Y, length(X) > 1 -> ok.
  
t6(X) when X -> ok.

t7(X) when not X -> ok.

t8(X) when size(X) > 1 -> ok.
  
