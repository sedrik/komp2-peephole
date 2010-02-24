%%% File    : bs18.erl
%%% Author  : Per Gustafsson <pergu@it.uu.se>
%%% Description : tests matching 64-bit ints which becomes big nums
%%% Created : 14 Sep 2006 by Per Gustafsson <pergu@it.uu.se>

-module(bs18).

-export([test/0,compile/1]).

compile(O) ->
  hipe:c(?MODULE,O).

test() ->
  ok=test_bigs(),
  {ok,2} = test_failing_c_calls(<<0:1,2:7>>),
  ok.

test_bigs() ->
  <<X:64/little>> = <<16#7fffffff7fffffff:64/little>>,
  true = (X == 16#7fffffff7fffffff),
  <<Y:64>> = <<16#7fffffff7fffffff:64>>,
  true = (Y == 16#7fffffff7fffffff),
  ok.

test_failing_c_calls(<<_:1,X:15/little>>) -> 
  X;
test_failing_c_calls(<<_:1,X:7/little>>) ->
  {ok,X}.
