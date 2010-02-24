% file: "length.erl"

-module(length).
-export([test/0,compile/1]).

len(L) -> len(0,L).
len(X,[_|T]) -> len(X+1,T);
len(X,[]) -> X.

make_list(X) -> make_list(X,[]).
make_list(0,L) -> L;
make_list(X,L) -> make_list(X-1,[0|L]).

loop(0,_,R) -> R;
loop(N,L,_) -> loop(N-1,L,len(L)).

test() ->
    L = make_list(2000),
    statistics(runtime),
    R = loop(2,L,0),
    {_,Time} = statistics(runtime),
    io:format("\nruntime = ~p msecs\nresult = ~p\n",[Time,R]),
    R.

compile(Flags) ->
    hipe:c(?MODULE,Flags).
