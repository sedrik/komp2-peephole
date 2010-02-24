%%-------------------------------------------------------------------
%% File    : fun1.erl
%% Author  : Kostis Sagonas <kostis@it.uu.se>
%% Description : Tests correct solving of constraints involving funs
%%		 and the handling of the new is_function/2 type guard.
%%
%% Created : 7 Feb 2005 by Kostis Sagonas <kostis@it.uu.se>
%%-------------------------------------------------------------------
-module(fun1).
-export([m/2, map/2, map2/2, mmap/2]).

m(F, L) -> lists:map(F, L).

map(F, [H|T]) ->
  [F(H) | map(F,T)];
map(F, []) when is_function(F) ->
  [].

map2(F, [H|T]) ->
  [F(H) | map2(F,T)];
map2(F, []) when is_function(F,1) ->
  [].

mmap(F, [H|T]) ->
  [F(H) | mmap(F,T)];
mmap(F, []) when is_function(F) ->
  [];
mmap({M,F}, L) ->
  mmap(fun(X) -> M:F(X) end, L).
