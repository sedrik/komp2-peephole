%% Creates a switch val with both an atom and an integer

-module(switch_val).
-export([test/0, compile/1]).

compile(Opts) ->
  hipe:c(?MODULE, [core|Opts]).

test() ->
  22 = test1(21), 
  b = test1(a),
  ok.

test1(21) -> 22;
test1(a) -> b.

