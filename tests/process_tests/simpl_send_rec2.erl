-module(simpl_send_rec2).
-export([test/0,compile/1]).

return_42() ->
    receive _ -> 42 end.

test() ->
    self() ! foo,
    return_42().

compile(Flags) ->
    hipe:c(?MODULE,Flags).

