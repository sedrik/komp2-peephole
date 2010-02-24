-module(ffun2).
-export([test/0,compile/1]).

test() ->
    %% compile([o2]),
    {{bar, 'x', 'y', 'z'}, {baz, 'z', 'y', 'x'}} = foo(),
    ok.

foo() ->
    F = fun bar/3,
    G = fun baz/3,
    {f(F), f(G)}.

bar(A, B, C) ->
    {bar, A, B, C}.

baz(A, B, C) ->
    {baz, C, B, A}.

f(F) ->
    F('x', 'y', 'z').

compile(Opts) ->
    hipe:c(?MODULE, [core|Opts]).
