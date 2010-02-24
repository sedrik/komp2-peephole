-module(ffun3).
-export([test/0,compile/1]).

test() ->
    %% compile([o2]),
    {{bar, 'x', 'y', 'z'}, {bar, 'x', 'y', 'z'}} = foo(),
    ok.

foo() ->
    F = fun bar/3,
    G = fun bar/3,
    {f(F), f(G)}.

bar(A, B, C) ->
    {bar, A, B, C}.

f(F) ->
    F('x', 'y', 'z').

compile(Opts) ->
    hipe:c(?MODULE, [core|Opts]).
