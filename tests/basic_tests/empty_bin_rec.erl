%% Program that crashed the R12B-0 BEAM compiler: internal error in v3_codegen
%% Fixed pretty much immediately and released as a patch to the public, but
%% the patch was not applied to our repository for about two weeks or so.

-module(empty_bin_rec).
-export([test/0, compile/1]).

-record(r, {a = <<>> :: binary(), b = 42 :: integer()}).

test() ->
  42 = t(#r{}),
  ok.

t(R) ->
  #r{a = <<>>} = R,
  R#r.b.

compile(Opts) ->
  hipe:c(?MODULE, Opts).
