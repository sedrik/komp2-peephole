%%%-------------------------------------------------------------------
%%% File    : newtypes1
%%% Author  : Miguel Jimenez <milingo83@gmail.com>
%%% Description : Dataflow analysis
%%%
%%% Created : 30 May 2007
%%%-------------------------------------------------------------------
-module(newtypes1).
-export([head/1, head_call1/0, head_call2/0, head_call3/0, f1/1, rec1/0, rec2/0]).

-type (new() :: byte()).
-type (anything() :: any()).
-type (new2() :: integer()|atom()).
-record(new, {first :: integer(), second :: new()}).
-type (recnew() :: #new{}).

-spec (head/1 :: (([A]) -> A) when is_subtype(A, new())).
-spec (head_call3/0 :: (() -> new())).
-spec (f1/1 :: ((new2()) -> [anything()] | integer())).
-spec (rec1/0 :: (() -> recnew())).
-spec (rec2/0 :: (() -> recnew())).


head([H|_T]) ->
    H.

head_call1() ->
    head([3,5,7]).

%% This should fail
head_call2() ->
    head([300,500,700]).

%% This should fail
head_call3() ->
    head([4,6,8]),
    5*100.

f1(X) when is_integer(X) ->
    lists1:subtract([X,X-2],[X,X/3]);
f1(X) when is_atom(X)->
    lists1:nth(1,f1(2)).

rec1() ->
    #new{first=1000, second=255}.

%% This should fail
rec2() ->
    #new{first=1000, second=300}.

