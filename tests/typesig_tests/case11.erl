%%%-------------------------------------------------------------------
%%% File    : case11.erl
%%% Author  : Tobias Lindahl <tobiasl@it.uu.se>
%%% Description : 
%%%
%%% Created :  3 Mar 2005 by Tobias Lindahl <tobiasl@it.uu.se>
%%%-------------------------------------------------------------------
-module(case11).
-export([t/1]).

t(X) ->
  F = 
    case X of
      1 -> a;
      2 -> b
    end,
  case X of
    1 -> F;
    2 -> ok
  end.
      
       
