%%-------------------------------------------------------------------
%% File    : fun2.erl
%% Author  : Kostis Sagonas <kostis@it.uu.se>
%% Description : Tests correct solving of recursive type constraints
%%		 involving lazily constructed lists (lists whose tail
%%		 is a fun).  This is taken from the code of 'dbg.erl'.
%%
%% Created : 14 Mar 2005 by Kostis Sagonas <kostis@it.uu.se>
%%-------------------------------------------------------------------
-module(fun2).
-export([mk_reader/2]).

%% Creates and returns a reader (lazy list).
mk_reader(ReadFun, Source) ->
    fun() ->
	    case read_term(ReadFun, Source) of
		{ok, Term} ->
		    [Term | mk_reader(ReadFun, Source)];
		eof ->
		    [] % end_of_trace
	    end
    end.

%% Generic read term function. 
%% Returns {ok, Term} | 'eof'. Exits on errors.

read_term(ReadFun, Source) ->
    case ReadFun(Source, 5) of
	Bin when is_binary(Bin) ->
	    read_term(ReadFun, Source, Bin);
	List when is_list(List) ->
	    read_term(ReadFun, Source, list_to_binary(List));
	eof ->
	    eof
    end.

read_term(ReadFun, Source, <<Op, Size:32>> = Tag) ->
    case Op of
	0 ->
	    case ReadFun(Source, Size) of
		eof ->
		    exit({'trace term missing', 
			  binary_to_list(Tag)});
		Bin when is_binary(Bin) ->
		    {ok, binary_to_term(Bin)};
		List when is_list(List) ->
		    {ok, binary_to_term(list_to_binary(List))}
	    end;
	1 ->
	    {ok, {drop, Size}};
	Junk ->
	    exit({'bad trace tag', Junk})
    end.
