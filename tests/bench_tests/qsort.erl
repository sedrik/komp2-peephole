% file: "qsort.erl"

-module(qsort).
-export([test/0,compile/1]).

qsort(L) -> qsort(L,[]).
qsort([H|T],L) -> partition(H,T,[],[],L);
qsort([],L)    -> L.

partition(Pivot,[H|T],A,B,L) when H < Pivot ->
  partition(Pivot,T,[H|A],B,L);
partition(Pivot,[H|T],A,B,L) ->
  partition(Pivot,T,A,[H|B],L);
partition(Pivot,[],A,B,L) ->
  qsort(A,[Pivot|qsort(B,L)]).

loop(0,_,R) -> R;
loop(N,L,_) -> loop(N-1,L,qsort(L)).

test() ->
    L = [27,74,17,33,94,18,46,83,65, 2,
	 32,53,28,85,99,47,28,82, 6,11,
	 55,29,39,81,90,37,10, 0,66,51,
	 7,21,85,27,31,63,75, 4,95,99,
	 11,28,61,74,18,92,40,53,59, 8],
    statistics(runtime),
    R = loop(2,L,0),
    {_,Time} = statistics(runtime),
    io:format("\nruntime = ~p msecs\nresult = ~p\n",[Time,length(R)]),
    length(R).

compile(Flags) ->
    hipe:c(?MODULE,Flags).
