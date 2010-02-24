-module(fun3).
-export([test/0,compile/1]).

test() ->
    compile([o2]),
    {{foo, 'x', 'a', 'b'}, {bar, 'y', 'a', 'b'}} = foo(),
    ok.

foo() ->
    A = 'a', B = 'b',
    bar(A, B).

bar(A, B) ->
    F = fun (X) -> {foo, X, A, B} end,
    baz(F, A, B).

baz(F, A, B) ->
    G = fun (Y) -> {bar, Y, A, B} end,
    {F('x'), G('y')}.

compile(Opts) ->
    hipe:c(?MODULE, [core|Opts]).
