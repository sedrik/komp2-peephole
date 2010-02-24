%%--------------------------------------------------------------------
%% Checks that the HiPE compiler dors not go into an infinite loop
%% ehen compiling strange functions like the auth/4 one bwloe.
%%
%% This is taken from a file sent to us by Martin Bjorklund @ Nottel
%% on 14th November 2004.  The problem is in the SSA unconver pass.
%%--------------------------------------------------------------------

-module(inf_loop_bug).
-export([test/0, compile/1]).
-export([auth/4]). %% needs to be exported so that it is retained.

test() ->
  ok.

compile(Opts) ->
  hipe:c(?MODULE, Opts).

%% Function that sends the HiPE compiler into an infinite loop.
auth(_,A,B,C) ->
  auth(A,B,C,[]).
