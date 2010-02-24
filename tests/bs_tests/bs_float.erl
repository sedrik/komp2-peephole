%%%-------------------------------------------------------------------
%%% File    : bs_float.erl
%%% Author  : Per Gustafsson <pergu@it.uu.se>
%%% Description : creates a binary containing an illegal float and
%%% tries to match it out
%%%
%%% Created : 16 Oct 2006 by Per Gustafsson <pergu@it.uu.se>
%%%-------------------------------------------------------------------
-module(bs_float).

-export([test/0,compile/1]).

compile(O) ->
  hipe:c(?MODULE,O).

test() ->
  Bin = <<-1:64>>,
  -1 = match(Bin),
  ok.

match(<<F:64/float>>) -> F;
match(<<I:64/integer-signed>>) -> I.
