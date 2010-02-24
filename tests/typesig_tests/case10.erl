%%%-------------------------------------------------------------------
%%% File    : case10.erl
%%% Author  : Tobias Lindahl <tobiasl@it.uu.se>
%%% Description : 
%%%
%%% Created :  1 Mar 2005 by Tobias Lindahl <tobiasl@it.uu.se>
%%%-------------------------------------------------------------------
-module(case10).
-export([t/2]).

t(A, B) ->
  case A of
    1 -> a;
    2 -> b
  end,
  case B of 
    1 -> a;
    2 -> b
  end.
	 
      
       
