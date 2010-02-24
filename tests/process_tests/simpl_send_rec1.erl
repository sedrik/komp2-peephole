-module(simpl_send_rec1).
-export([test/0,compile/1]).

l() ->
    self() ! 21,
    self() ! 42.

m() ->
    B = l(),
    {receive 42 -> 42 end, receive A -> A end, B}.

test() ->
    m().

compile(Flags) ->
    hipe:c(?MODULE,Flags).

