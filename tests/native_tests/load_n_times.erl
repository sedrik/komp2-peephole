%% ====================================================================
%% Test module for the HiPE test suite.
%%
%%  Filename : trivial_00.erl
%%  Module   : trivial_00
%%  Purpose  : To test the native code loader whether a file can be
%%	       loaded a number of times without hanging the system
%%	       and without any space leaks in the constants area.
%% CVS:
%%    $Author: kostis $
%%    $Date: 2003/12/16 15:51:09 $
%%    $ $
%% ====================================================================
%% Exported functions (short description):
%%  test()         - execute the test.
%%  compile(Flags) - Compile to native code with compiler flags Flags.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-module(load_n_times).
-export([test/0,compile/1]).

test() ->
  Mod = load_n_times_input,
  {ok,Mod} = c:c(Mod,[native]),
  C = hipe_bifs:constants_size(),
  %% compile to native code and load the file 10 times
  [ {ok,Mod} = c:c(Mod,[native]) || _N <- lists:seq(1,10) ],
  %% check that there is no space growth/leakage in the constants area
  C = hipe_bifs:constants_size(),
  ok.

compile(Flags) ->
  hipe:c(?MODULE,Flags).
