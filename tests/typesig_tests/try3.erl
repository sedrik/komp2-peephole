%%%-------------------------------------------------------------------
%%% File    : try3.erl
%%% Author  : Kostis Sagonas <kostis@it.uu.se>
%%% Description : A test inspired by 'kernel/src/zlib.erl' to exercise
%%%               the treatment of try-catch.
%%%
%%% Created :  2 Jul 2006 by Kostis Sagonas <kostis@it.uu.se>
%%%-------------------------------------------------------------------
-module(try3).
-export([deflate/3]).

deflate(Z, Data, Flush) ->
    try port_command(Z, Data) of
	true ->
	    call(Z, 7, <<(arg_flush(Flush)):32>>),
	    collect(Z)
    catch 
	error:_Err ->
	    flush(Z),
	    erlang:error(badarg) 
    end.

collect(Z) -> 
    collect(Z,[]).

collect(Z,Acc) ->
    receive 
	{Z, {data, Bin}} ->
	    collect(Z,[Bin|Acc])
    after 0 ->
	    lists:reverse(Acc)
    end.

flush(Z) ->
    receive
	{Z, {data,_}} ->
	    flush(Z)
    after 0 ->
	    ok
    end.

arg_flush(none) -> 0;
arg_flush(sync) -> 1.

call(Z, Cmd, Arg) ->
    try port_control(Z, Cmd, Arg) of
	[0|Res] -> list_to_atom(Res);
	[1|Res] ->
	    flush(Z),
	    erlang:error(list_to_atom(Res));
	[2,A,B,C,D] ->
	    (A bsl 24)+(B bsl 16)+(C bsl 8)+D;
	[3,A,B,C,D] ->
	    erlang:error({need_dictionary,(A bsl 24)+(B bsl 16)+(C bsl 8)+D})
    catch 
	error:badarg -> %% Rethrow loses port_control from stacktrace.
	    erlang:error(badarg)
    end.
