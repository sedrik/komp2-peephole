-module(tuple4).
-export([to_tuple/1]).

to_tuple(T) when is_tuple(T) -> T;
to_tuple(I) when is_integer(I) -> {I}.
