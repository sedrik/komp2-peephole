%%%-------------------------------------------------------------------
%%% File    : lists_all_any.erl
%%% Author  : Tobias Lindahl <tobiasl@csd.uu.se>
%%% Description :
%%%
%%% Created : 29 Jan 2007 by Tobias Lindahl <tobiasl@csd.uu.se>
%%%-------------------------------------------------------------------
-module(lists_all_any).

-compile(export_all).

all_none() ->
  lists:all(fun(X) when is_atom(X) -> true end, [1,2]).

all_true1() ->
  lists:all(fun(X) when is_atom(X) -> true end, [foo, bar]).

all_true2() ->
  lists:all(fun(X) when is_atom(X) -> false end, []).

all_false1() ->
  lists:all(fun(X) when is_atom(X) -> false end, [foo, bar]).

all_false2(X = [_|_]) ->
  lists:all(fun(X) when is_atom(X) -> false end, X).

all_bool(X) ->
  lists:all(fun(X) when is_atom(X) -> false;
	       (X) when is_integer(X) -> true
	    end, X).

any_none() ->
  lists:any(fun(X) when is_atom(X) -> true end, [1,2]).

any_true() ->
  lists:any(fun(X) when is_atom(X) -> true end, [foo, bar]).

any_false1() ->
  lists:any(fun(X) when is_atom(X) -> false end, [foo, bar]).

any_false2(X = [_|_]) ->
  lists:any(fun(X) when is_atom(X) -> false end, X).

any_false2() ->
  lists:any(fun(X) when is_atom(X) -> true end, []).

any_bool(X) ->
  lists:any(fun(X) when is_atom(X) -> false;
	       (X) when is_integer(X) -> true
	    end, X).

foreach_none() ->
  lists:foreach(fun(X) when is_atom(X) -> ok end, [1, 2]).

foreach_ok() ->
  lists:foreach(fun(X) when is_integer(X) -> ok end, [1, 2]).
		    
