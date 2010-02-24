-module(fun4).
-export([test/0,compile/1]).

test() ->
%    compile([o2]),
    {{fee, 'x', 'a', 'b'}, {fie, 'y', 'b', 'a'},
     {foe, 'x', 'a', 'b'}, {fum, 'y', 'b', 'a'}} = foo(),
    ok.

foo() ->
    A = 'a', B = 'b',
    bar(A, B).

bar(A, B) ->
    F1 = fun (X) -> {fee, X, A, B} end,
    F2 = fun (Y) -> {fie, Y, B, A} end,
    baz(F1, F2, A, B).

baz(F1, F2, A, B) ->
    G1 = fun (X) -> {foe, X, A, B} end,
    G2 = fun (Y) -> {fum, Y, B, A} end,
    {F1('x'), F2('y'), G1('x'), G2('y')}.

compile(Opts) ->
    hipe:c(?MODULE, [core|Opts]).
