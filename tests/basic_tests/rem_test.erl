-module(rem_test).
-export([test/0,compile/1]).

test() ->
     2 = ret_rem(42,20),
    -2 = ret_rem(-42,20),
    -2 = ret_rem(-42,-20),
    {'EXIT',{badarith,_}} = ret_rem(3.14,2),
    {'EXIT',{badarith,_}} = ret_rem(42,3.14),
    ok.

ret_rem(X,Y) ->
    catch X rem Y.

compile(Flags) ->
    hipe:c(?MODULE,Flags).

