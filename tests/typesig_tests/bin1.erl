%%%-------------------------------------------------------------------
%%% File    : bin1.erl
%%% Author  : Tobias Lindahl <tobiasl@csd.uu.se>
%%% Description : Excercise binary matching.
%%%
%%% Created : 20 Mar 2006 by Tobias Lindahl <tobiasl@csd.uu.se>
%%%-------------------------------------------------------------------
-module(bin1).

-export([t/0]).

t()->
  t(<<1,2,3>>).

t(Bin) -> 
  <<I,B/binary>> = Bin,
  {I, B}.
  
