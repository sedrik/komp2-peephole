-module(tuple4).
-export([to_tuple/1]).

-spec (to_tuple/1 :: ((X) -> {X}) when is_subtype(X,integer())).
to_tuple(T) when is_tuple(T) -> T;
to_tuple(I) when is_integer(I) -> {I}.
