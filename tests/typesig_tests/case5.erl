%%%-------------------------------------------------------------------
%%% File    : case5.erl
%%% Author  : Tobias Lindahl <tobiasl@it.uu.se>
%%% Description : 
%%%
%%% Created : 10 Jan 2005 by Tobias Lindahl <tobiasl@it.uu.se>
%%%-------------------------------------------------------------------
-module(case5).
-export([t/2]).

t(X, Y) ->
  case X of 
    2 ->
      case Y of
	1 -> ok;
	X -> error
      end
  end.
