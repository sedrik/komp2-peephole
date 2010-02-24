%%%-------------------------------------------------------------------
%%% File    : try1.erl
%%% Author  : Tobias Lindahl <tobiasl@it.uu.se>
%%% Description : 
%%%
%%% Created :  5 Jan 2005 by Tobias Lindahl <tobiasl@it.uu.se>
%%%-------------------------------------------------------------------
-module(try1).
-export([t/2]).

t(X, Y) ->
  try X + 1 of
      5 -> Y+1
  catch 
    _:_ when is_atom(X) -> Y+1
  end.
 
