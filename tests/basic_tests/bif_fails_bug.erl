%% This module was causing the HiPE compiler to crash in January 2007.
%% The culprit was an "optimization" of the BEAM compiler: postponing
%% the save of x variables when BIFs cannot fail.  This was fixed on
%% February 1st, by making the HiPE compiler use the same functions
%% ss the BEAM compiler for deciding whether a BIF fails.

-module(bif_fails_bug).
-export([test/0, compile/1]).
-export([c/1, tc/1]). % so that they are not unused

test() ->
  MFA1 = {?MODULE, c, 1},
  {ok, MFA1} = hipe:c(MFA1),
  MFA2 = {?MODULE, tc, 1},
  {ok, MFA2} = hipe:c(MFA2),
  ok.

c(X) ->
  case catch get(gazonk) of
    _ -> X
  end.

tc(Fs) ->
  try
    true = Fs =/= []
  catch _ ->
    bit_elems(Fs)
  end.

bit_elems(_Fs) ->
  [].

compile(Opts) ->
  hipe:c(?MODULE, Opts).
