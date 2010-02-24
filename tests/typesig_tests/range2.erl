%%%-------------------------------------------------------------------
%%% File    : range2.erl
%%% Author  : Tobias Lindahl <tobiasl@csd.uu.se>
%%% Description : This exposed a bug in the handling of integer division 
%%%               (as the inverse of the multiplication in the code).
%%%
%%% Created :  9 Jan 2007 by Tobias Lindahl <tobiasl@csd.uu.se>
%%%-------------------------------------------------------------------
-module(range2).

-export([t/2]).

t(Tree, Pos) -> 
  element(Pos*2-1, Tree).
