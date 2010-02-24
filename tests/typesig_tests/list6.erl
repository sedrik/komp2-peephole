%%-------------------------------------------------------------------
%% File    : list6.erl
%% Author  : Kostis Sagonas <kostis@it.uu.se>
%% Description : Tests module-local propagation of type information.
%%		 (Code taken from stdlib/src/lists.erl)
%%
%% Created : 16 Mar 2005 by Kostis Sagonas <kostis@it.uu.se>
%%-------------------------------------------------------------------

-module(list6).
-export([flatten/1, flatten/2, flatlength/1]).

%% flatten(List)
%% flatten(List, Tail)
%%  Flatten a list, adding optional tail.

flatten(List) when is_list(List) ->
    do_flatten(List, []).

flatten(List, Tail) when is_list(List), is_list(Tail) ->
    do_flatten(List, Tail).

do_flatten([H|T], Tail) when is_list(H) ->
    do_flatten(H, do_flatten(T, Tail));
do_flatten([H|T], Tail) ->
    [H|do_flatten(T, Tail)];
do_flatten([], Tail) ->
    Tail.

%% flatlength(List)
%%  Calculate the length of a list of lists.

flatlength(List) ->
    flatlength(List, 0).

flatlength([H|T], Len) when is_list(H) ->
    flatlength(H, flatlength(T, Len));
flatlength([_|T], Len) ->
    flatlength(T, Len + 1);
flatlength([], Len) -> Len.

