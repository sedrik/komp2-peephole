-module(pmatch1).
-export([test/0,compile/1]).

test() ->
  compile([o2]),
  foo(2,2) + foo(1,0) - foo(1,2) + foo(2,0) + 2.

foo(1,0) -> 10;
foo(2,0) -> 20;
foo(1,2) -> 12;
foo(2,2) -> 22;
foo(X,Y) -> {X,Y}.

compile(Opts) ->
  hipe:c(?MODULE, [core|Opts]).
