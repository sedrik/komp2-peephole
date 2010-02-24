-module(lc2).
-export([test/0,compile/1]).

test() ->
    compile([o2]),
    foo([1,2,3,4], foo).

foo(Xs, A) ->
    [{A, X} || X <- Xs].

compile(Opts) ->
    hipe:c(?MODULE, [core|Opts]).
