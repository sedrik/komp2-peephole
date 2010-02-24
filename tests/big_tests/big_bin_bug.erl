%%======================================================================
%% From: Hynek Vychodil
%% Date: 2 Jun 18, 2009
%%
%% Bug in HiPE big binary matching.  When compiled in BEAM it works OK.
%% When compiled with HiPE it results in a "no match of right hand side
%% value" exception.
%%======================================================================

-module(big_bin_bug).

-export([test/0, compile/1]).

test() ->
    <<_:4/bytes, I:32, _/bytes>> = make_pidle(100000000),
    I.

make_pidle(N) -> make_pidle(<<>>, 0, N).

make_pidle(P, N, N) -> P;
make_pidle(P, I, N) -> make_pidle(<<P/bytes, I:32>>, I+1, N).

compile(Opts) -> hipe:c(?MODULE, Opts).
