-module(lc1).
-export([test/0,compile/1]).

test() ->
    compile([o2]),
    foo([1,2,3,4]).

foo(Xs) ->
    [X + 1 || X <- Xs].

compile(Opts) ->
    hipe:c(?MODULE, [core|Opts]).
