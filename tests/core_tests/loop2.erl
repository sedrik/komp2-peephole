-module(loop2).
-export([test/0,compile/1]).

test() ->
    compile([o2]),
    foo(10).

foo(N) when N > 0 ->
    bar(N - 1);
foo(_) ->
    foo.

bar(N) when N > 0 ->
    foo(N - 1);
bar(_) ->
    bar.

compile(Opts) ->
    hipe:c(?MODULE, [core|Opts]).
