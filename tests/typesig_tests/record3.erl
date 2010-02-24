%% Program that shows how type information is completely lost when
%% accessing individual elements of records via the . notation.
%% This problem should be fixed.	- Kostis

-module(record3).
-export([m/1]).

-record(dict, {n=42::integer(), empty, segs}).

m(T) when is_integer(T#dict.n) ->
    T#dict{segs = expand_segs(T#dict.segs, T#dict.empty)}.

expand_segs(Segs, Empty) ->
    list_to_tuple(tuple_to_list(Segs) ++ lists:duplicate(size(Segs), Empty)).

