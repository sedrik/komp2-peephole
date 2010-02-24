%%---------------------------------------------------------------------
%% File    : try4.erl
%% Author  : Kostis Sagonas <kostis@it.uu.se>
%% Description : A test inspired by 'kernel/src/file.erl' to make sure
%%               the treatment of try expressions is correct.  When the
%%               test was created, it was not -- wrong success typings
%%               are generated for file_name/1.
%%
%% Created :  23 Nov 2006 by Kostis Sagonas <kostis@it.uu.se>
%%---------------------------------------------------------------------
-module(try4).
-export([file_name/1]).

%% file_name/1 :: any() -> [integer()] | {error, einval}
file_name(N) ->
    try
        file_name_1(N)
    catch _:_ ->
        {error, einval}
    end.

file_name_1([C|T]) when is_integer(C), C > 0, C =< 255 ->
    [C|file_name_1(T)];
file_name_1([H|T]) ->
    file_name_1(H) ++ file_name_1(T);
file_name_1([]) ->
    [];
file_name_1(N) when is_atom(N) ->
    atom_to_list(N).

