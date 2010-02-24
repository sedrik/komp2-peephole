-module(int_overfl).
-export([test/0,compile/1]).

test() ->
    16#7FFFFFF = add(16#7FFFFFF,0),
    16#8000000 = add(16#8000000,0),
    16#8000001 = add(16#8000000,1),
    case add(16#7FFFFFF,1) of
        16#8000000 -> ok;
       -16#7FFFFFF -> error
    end.

add(X,Y) ->
    X + Y.

compile(Flags) ->
    hipe:c(?MODULE,Flags).

