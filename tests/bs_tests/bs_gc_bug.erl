%%%-------------------------------------------------------------------
%%% File    : bs_gc_bug.erl
%%% Author  : Per Gustafsson <pergu@dhcp-12-245.it.uu.se>
%%% Description : 
%%%
%%% Created : 29 Sep 2006 by Per Gustafsson <pergu@dhcp-12-245.it.uu.se>
%%%-------------------------------------------------------------------
-module(bs_gc_bug).

-export([test/0,compile/1]).

compile(O) ->
  hipe:c(?MODULE,O).

test() ->
  Bin = <<16#76543210:32>>,
  16#76543210 = match_a_lot(Bin,1000000),
  ok.

match_a_lot(<<X:32>>,0) ->
  X;
match_a_lot(<<X:32>>,N) ->
  match_a_lot(<<X:32>>,N-1).
