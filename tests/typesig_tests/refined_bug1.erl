-module(refined_bug1).
-export([chars/2]).

chars(C, N) -> chars(C, N, []).

chars(C, N, Tail) when is_integer(C), is_integer(N), is_list(Tail) ->
    chars1(C, N, Tail).

chars1(C, N, Tail) when N > 0 ->
    chars1(C, N-1, [C|Tail]);
chars1(C, 0, Tail) when is_integer(C) ->
    Tail.

