%% Based on a bug report from Jon Meredith 2009-07-09.
%% Fixed by Mikael Pettersson 2009-07-10.
%%
%% Binary search key tables are sorted by the loader based on
%% the runtime representations of the keys as unsigned words.
%% However, the code generated for the binary search used signed
%% comparisons. That worked for atoms and non-negative fixnums,
%% but not for negative fixnums.

-module(switch_neg_int).
-export([test/0, g/1, compile/1]).

test() ->
  test(-80, 8).

test(10, -1) -> ok;
test(X, Y) ->
  Y = g(X),
  test(X+10, Y-1).

g(X) ->	% g(0) should be 0 but became -1
  case X of
      0 -> 0;
    -10 -> 1;
    -20 -> 2;
    -30 -> 3;
    -40 -> 4;
    -50 -> 5;
    -60 -> 6;
    -70 -> 7;
    -80 -> 8;
      _ -> -1
  end.

compile(Opts) ->
  hipe:c(?MODULE, Opts).
