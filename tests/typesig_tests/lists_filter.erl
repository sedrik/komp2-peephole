%%%-------------------------------------------------------------------
%%% File    : lists_filter.erl
%%% Author  : Tobias Lindahl <tobiasl@csd.uu.se>
%%% Description : 
%%%
%%% Created : 29 Jan 2007 by Tobias Lindahl <tobiasl@csd.uu.se>
%%%-------------------------------------------------------------------
-module(lists_filter).

-compile(export_all).

filter_none() ->
  lists:filter(fun(X) when is_atom(X) -> true end, [1,2]).

filter_nil() ->
  lists:filter(fun(X) when is_integer(X) -> false end, [1,2]).

filter_list() ->
  lists:filter(fun(X) when is_integer(X) -> true;
		  (_) -> false
	       end, [1,2]).

filter_nonempty() ->
  lists:filter(fun(X) when is_integer(X) -> true end, [1,2]).

dropwhile_none() ->
  lists:dropwhile(fun(X) when is_atom(X) -> true end, [1,2]).

dropwhile_nil() ->
  lists:dropwhile(fun(X) when is_integer(X) -> true end, [1,2]).

dropwhile_list() ->
  lists:dropwhile(fun(X) when is_integer(X) -> true;
		     (_) -> false
		  end, [1,2]).

dropwhile_improper_list() ->
  lists:dropwhile(fun(X) when is_integer(X) -> true;
		     (_) -> false
		  end, [1,2,3.14|foo]).

dropwhile_nonempty() ->
  lists:dropwhile(fun(X) when is_integer(X) -> false end, [1,2]).

takewhile_none() ->
  lists:takewhile(fun(X) when is_atom(X) -> false end, [1,2]).

takewhile_nil() ->
  lists:takewhile(fun(X) when is_integer(X) -> false end, [1,2]).

takewhile_list1() ->
  lists:takewhile(fun(X) when is_integer(X) -> true;
		     (_) -> false
		  end, [1,2]).

takewhile_list2() ->
  lists:takewhile(fun(X) when is_integer(X) -> true;
		     (_) -> false
		  end, [1,2,3.14|foo]).

takewhile_nonempty() ->
  lists:takewhile(fun(X) when is_integer(X) -> true end, [1,2]).

partition_nil_list() ->
  lists:partition(fun(X) when is_integer(X) -> false end, [1,2]).

partition_list_nil() ->
  lists:partition(fun(X) when is_integer(X) -> true end, [1,2]).

partition_list_list(X) ->
  lists:partition(fun(X) when is_integer(X) -> true;
		     (_) -> false
		  end, X).

splitwith_none() ->
  lists:splitwith(fun(X) when is_atom(X) -> false end, [1,2]).

splitwith_nil_list() ->
  lists:splitwith(fun(X) when is_integer(X) -> false end, [1,2]).

splitwith_list_nil() ->
  lists:splitwith(fun(X) when is_integer(X) -> true end, [1,2]).

splitwith_list_list() ->
  lists:splitwith(fun(X) when is_integer(X) -> true;
		     (_) -> false
		  end, [1,2]).
