%%%-------------------------------------------------------------------
%%% File    : letrec1.erl
%%% Author  : Tobias Lindahl <tobiasl@csd.uu.se>
%%% Description : Test some versions of list comprehensions that are 
%%%               compiled into letrecs in Core Erlang.
%%%
%%% Created : 13 Dec 2005 by Tobias Lindahl <tobiasl@csd.uu.se>
%%%-------------------------------------------------------------------
-module(letrec1).

-export([t1/1, t2/1, t3/1, t4/1]).


%% ([number()]) -> [number()]
t1(List) ->
  [X + 1 || X <- List].


%% This signature might confuse you, but if you think about it it is
%% actually correct since guards are allowed to fail.
%%
%% ([any()]) -> [integer()]
t2(List) ->
  [X + 1 || X <- List, is_integer(X)].

%% ([number()]) -> [number()]
t3(List) ->
  [add_one(X) || X <- List].

add_one(X) ->
  X + 1.

%% ([integer()]) -> [integer()]
t4(List) ->
  [add_one_int(X) || X <- List].

add_one_int(X) when is_integer(X) ->
  X + 1.
		
