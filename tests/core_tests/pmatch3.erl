-module(pmatch3).
-export([test/0,compile/1]).

test() ->
    compile([o2]),
    foo(2,2) + foo(1,0) - foo(1,2) + foo(2,0) + 2.

foo(X, Y) ->
    Z = case {X, Y} of
	    {1,0} -> 10;
	    {2,0} -> 20;
	    {1,2} -> 12;
	    {2,2} -> 22;
	    _ ->
		3
	end,
    Z + 1.

compile(Opts) ->
  hipe:c(?MODULE, [core|Opts]).
