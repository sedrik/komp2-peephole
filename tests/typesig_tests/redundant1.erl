%% Module that contains various kinds of redundant clauses.
%% It shows how success typings might overapproximate the return type.
%% I am not so sure much can be done about it -- perhaps the BEAM
%% compiler might be interested in warning about these redundancies.

-module(redundant1).
-export([a/1, b/1, c/1]).

-record(rec, {a}).

a(T) when is_tuple(T) -> tuple;
a(R) when is_record(R, rec) -> record.

b(I) when is_number(I) -> number;
b(I) when is_integer(I) -> integer.

%% This one was fixed in the end of January 2007
c(0) -> first_zero;
c(0) -> another_zero.
