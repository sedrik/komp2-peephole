%% -*- erlang-indent-level: 2 -*-
%%-------------------------------------------------------------------
%% File        : bs_native.erl
%% Author      : Kostis Sagonas
%% Description : Test sent by Bjorn Gustavsson to report a bug in the
%%               handling of the 'native' endian specifier.
%% Created     : 28 Nov 2004
%%-------------------------------------------------------------------

-module(bs_native).
-export([test/0, compile/1]).

test() ->
  BeamRes = vs_to_bin({1.0,2.0,3.0}),
  hipe:c({?MODULE,vs_to_bin,1}, [o2]),
  HipeRes = vs_to_bin({1.0,2.0,3.0}),
  %% io:format("Beam result = ~w\nHiPE result = ~w\n", [BeamRes,HipeRes]),
  BeamRes = HipeRes,
  ok.

vs_to_bin({X,Y,Z}) ->
  <<X:64/native-float,Y:64/native-float,Z:64/native-float>>.

compile(Opts) ->
  hipe:c(?MODULE, Opts).
