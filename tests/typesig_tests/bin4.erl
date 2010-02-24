-module(bin4).
-export([list_to_binlist/1]).

list_to_binlist(List) ->
    {intlist_to_binlist(List, []), rnglist_to_binlist(List, [])}.

intlist_to_binlist([N | L], Acc) ->
    intlist_to_binlist(L, [<<N:32>> | Acc]);
intlist_to_binlist([], Acc) ->
    Acc.

rnglist_to_binlist([N | L], Acc) when is_integer(N), 0 =< N, N =< 4294967295 ->
    rnglist_to_binlist(L, [<<N:32>> | Acc]);
rnglist_to_binlist([], Acc) ->
    Acc.
