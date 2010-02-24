%%%-------------------------------------------------------------------
%%% File    : lists_map.erl
%%% Author  : Tobias Lindahl <tobiasl@csd.uu.se>
%%% Description : 
%%%
%%% Created : 29 Jan 2007 by Tobias Lindahl <tobiasl@csd.uu.se>
%%%-------------------------------------------------------------------
-module(lists_map).

-compile(export_all).

map_list() ->
  lists:map(fun(X) -> X end, [a,b]).

map_int_list() ->
  lists:map(fun(X) when is_integer(X) -> X + 1 end, [1,2]).

map_nil1() ->
  lists:map(fun(X) when is_atom(X) -> X + 1 end, []).

%% Would like to find out that X :: [], but this is pretty hard.
%% Have to settle for knowing that the return must be [].
map_nil2(X) ->
  lists:map(fun(X) when is_atom(X) -> X + 1 end, X).

map_none1() ->
  lists:map(fun(X) when is_atom(X) -> X + 1 end, [a,b]).

map_none2() ->
  lists:map(fun(X) when is_integer(X) -> X + 1 end, [a,b]).

flatmap1() ->
  lists:flatmap(fun(X) -> [X,X] end, [a,b]).

flatmap2() ->
  lists:flatmap(fun(X) when is_integer(X) -> [X+1] end, [1,2]).

flatmap_nil1() ->
  lists:flatmap(fun(X) when is_atom(X) -> [X+1] end, []).

%% Would like to find out that X :: [], but this is pretty hard.
%% Have to settle for knowing that the return must be [].
flatmap_nil2(X) ->
  lists:flatmap(fun(X) when is_atom(X) -> [X+1] end, X).

flatmap_none1() ->
  lists:flatmap(fun(X) when is_atom(X) -> [X+1] end, [a,b]).

flatmap_none2() ->
  lists:flatmap(fun(X) when is_integer(X) -> [X+1] end, [a,b]).
