%%%-------------------------------------------------------------------
%%% File    : list1.erl
%%% Author  : Tobias Lindahl <tobias@it.uu.se>
%%% Description : 
%%%
%%% Created :  3 Mar 2003 by Tobias Lindahl <tobias@it.uu.se>
%%%-------------------------------------------------------------------

-module(list1).
-export([doit/0, append/2, reverse/1, lists__reverse/1, reverse_acc/1]).

doit() ->
  {len([1, 2, 3], 0)}.

len([_|T], Acc) ->
  len(T, Acc+1);
len([], Acc) when is_integer(Acc) ->
  Acc.

append([H|T], Z) ->
   [H|append(T, Z)];
append([], X) ->
   X.

reverse([H|T]) ->
  reverse(T) ++ [H];
reverse([]) ->
  [].

lists__reverse(L) ->
   lists:reverse(L).

reverse_acc(L) ->
   reverse_acc(L, []).

reverse_acc([], Acc) -> % when length(Acc) >= 0 ->
   Acc;
reverse_acc([H|T], Acc) ->
   reverse_acc(T, [H|Acc]).
