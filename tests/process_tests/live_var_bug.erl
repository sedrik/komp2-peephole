%% This module was an open Erlang/OTP bug for a long time. The live
%% variable analyzer of the BEAM compiler was confused by the
%% occurrence of the "A" variable on only one branch of the receive
%% statement. It was finally fixed on 28 Feb 2003.

-module(live_var_bug).
-export([test/0,compile/1]).

test() ->
    receive
    after 10 ->
        R = ok
    end,
    R.

compile(Flags) ->
    hipe:c(?MODULE,Flags).
