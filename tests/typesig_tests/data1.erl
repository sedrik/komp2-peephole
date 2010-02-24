%%-------------------------------------------------------------------
%% File    : data1.erl
%% Author  : Kostis Sagonas <kostis@it.uu.se>
%% Description : Tests that the shape of nested data structures is
%%		 properly inferred.  Also, it compares precision of
%%		 cut-off depths of the two type analyses.
%%
%% Created : 31 Jan 2005 by Kostis Sagonas <kostis@it.uu.se>
%%-------------------------------------------------------------------
-module(data1).
-export([build/1]).

build(Data) ->
   build(Data, 0).

build(_, 256) ->
   [];
build(Data, X) ->
   [{occurs(X, Data, 0), leaf, X} | build(Data, X+1)].

occurs(_, [], Ack) ->
   Ack;
occurs(X, [Y|Rest], Ack) when X == Y ->
   occurs(X, Rest, Ack+1);
occurs(X, [_|Rest], Ack) ->
   occurs(X, Rest, Ack).

