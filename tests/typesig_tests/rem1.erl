%%----------------------------------------------------------------------------
%% Test for type and range pruning when applying the integer 'rem' operator.
%%----------------------------------------------------------------------------

-module(rem1).
-export([t/1]).

t(X) ->
  I = case X > 0 of
	true  -> foo(X);
	false -> bar(X)
      end,
  I rem 8.

foo(X) when is_integer(X) -> X rem 2.

bar(X) when is_float(X) -> X.

