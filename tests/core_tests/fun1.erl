-module(fun1).
-export([test/0,compile/1]).

test() ->
    %compile([o2]),
    {foo, 'x', 'y', 'z', 'a', 'b', 'c'} = foo(),
    ok.

foo() ->
    A = 'a', B = 'b', C = 'c',
    bar(A, B, C).

bar(A, B, C) ->
    F = fun (X, Y, Z) -> {foo, X, Y, Z, A, B, C} end,
    baz(F).

baz(F) ->
    F('x', 'y', 'z').

compile(Opts) ->
    hipe:c(?MODULE, [core|Opts]).
