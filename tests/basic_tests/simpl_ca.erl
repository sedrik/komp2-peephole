-module(simpl_ca).
-export([test/0,compile/1]).

test() ->
    catch exit(42).

compile(Flags) ->
    hipe:c(?MODULE,Flags).
