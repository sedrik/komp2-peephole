%%%-------------------------------------------------------------------
%%% File    : alias1.erl
%%% Author  : Tobias Lindahl <tobiasl@it.uu.se>
%%% Description : 
%%%
%%% Created : 25 Jan 2005 by Tobias Lindahl <tobiasl@it.uu.se>
%%%-------------------------------------------------------------------
-module(alias1).

-export([t/1]).

t({foo, Y} = X) -> 
  case X of
    Z = {_, bar} -> Z
  end.

