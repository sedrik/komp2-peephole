%%%-------------------------------------------------------------------
%%% File    : bin7.erl
%%% Author  : Tobias Lindahl <tobiasl@csd.uu.se>
%%% Description : Test when size of a field is bound.
%%%
%%% Created : 27 Sep 2007 by Tobias Lindahl <tobiasl@csd.uu.se>
%%%-------------------------------------------------------------------
-module(bin7).

-export([t1/0, t2/0]).

t1() ->
  match1(8, <<1,2,3>>).

t2() ->
  match2(<<8, 1,2,3>>).

match1(Size, Bin) ->
  <<X:Size, Bin1/binary>> = Bin,
  {X, Bin1}.

match2(<<Size, Bin/binary>>) ->
  {Size, Bin}.
