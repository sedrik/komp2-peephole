-module(ffun1).
-export([test/0,compile/1]).

test() ->
    %% compile([o2]),
    {foo, 'x', 'y', 'z'} = foo(),
    ok.

foo() ->
    F = fun bar/3,
    baz(F).

bar(A, B, C) ->
    {foo, A, B, C}.

baz(F) ->
    F('x', 'y', 'z').

compile(Opts) ->
    hipe:c(?MODULE, [core|Opts]).
