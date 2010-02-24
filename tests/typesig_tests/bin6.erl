%%%-------------------------------------------------------------------
%%% File    : bin6.erl
%%% Author  : Tobias Lindahl <tobiasl@csd.uu.se>
%%% Description : 
%%%
%%% Created :  8 Mar 2007 by Tobias Lindahl <tobiasl@csd.uu.se>
%%%-------------------------------------------------------------------
-module(bin6).

-export([t1/1, t2/1, t3/1, t4/1]).

t1(X) ->
  {<<X:1>>, X}.

t2(X) ->
  {<<X:64/float>>, X}.

t3(X) when is_float(X) ->
  {<<X:64>>, X}.

t4(X) when is_float(X) ->
  {<<64:X>>, X}.
