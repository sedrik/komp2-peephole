-module(orelse1).
-export([test/0, compile/1]).

test() ->
  ok = zero_one_in_heads(1),
  ok = zero_one_in_or_guard(1),
  ok = zero_one_in_orelse_guard(1),
  ok.

zero_one_in_heads(0) -> ok;
zero_one_in_heads(1) -> ok.

zero_one_in_or_guard(N) when (N =:= 0) ; (N =:= 1) -> ok.

zero_one_in_orelse_guard(N) when (N =:= 0) orelse (N =:= 1) -> ok.

compile(Opts) ->
  hipe:c(?MODULE, [core, {pmatch, no_duplicates}|Opts]).

