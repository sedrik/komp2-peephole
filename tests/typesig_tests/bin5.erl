%%%-------------------------------------------------------------------
%%% File    : bin5.erl
%%% Author  : Tobias Lindahl <tobiasl@csd.uu.se>
%%% Description : 
%%%
%%% Created : 27 Sep 2006 by Tobias Lindahl <tobiasl@csd.uu.se>
%%%-------------------------------------------------------------------
-module(bin5).

-export([t/1]).

t(<<X:3, Y:5>>) ->
  [X, Y].
