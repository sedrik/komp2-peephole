% file: "nrev.erl"

-module(nrev).
-export([test/0,compile/1]).

nrev([H|T]) -> app(nrev(T),[H]);
nrev([])    -> [].

app([H|T],L) -> [H|app(T,L)];
app([],L)    -> L.

iota(N) -> iota(N,[]).
iota(0,L) -> L;
iota(N,L) -> iota(N-1,[N|L]).

loop(0,_,R) -> R;
loop(N,L,_) -> loop(N-1,L,nrev(L)).

test() ->
    L = iota(100),
    statistics(runtime),
    R = loop(2,L,0),
    {_,Time} = statistics(runtime),
    io:format("\nruntime = ~p msecs\nresult = ~p\n",[Time,length(R)]),
    length(R).

compile(Flags) ->
    hipe:c(?MODULE,Flags).
