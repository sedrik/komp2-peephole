-module(rtl_prop_bug).

-export([test/0, compile/1]).
-export([t/3]).

test() ->
  MFA = {?MODULE,t,3},
  {ok, MFA} = hipe:c(MFA, [split_arith,o2]),
  ok.

t([1|_], _, _) ->
    t(1, 1, 1);
t([Row | A], B, C) ->
    t(A, [Row-1|B],
      case C of
	[Z2 | R] ->
	  [1+Z2|R];
	R ->
	  R
      end ).

compile(Opts) ->
  hipe:c(?MODULE, Opts).
