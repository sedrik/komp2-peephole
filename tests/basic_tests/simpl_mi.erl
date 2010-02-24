%% ====================================================================
%% Test module for the HiPE test suite.
%%
%%  Filename :  simpl_mi.erl
%%  Module   :  simpl_mi
%%  Purpose  :  Tests whether calling module_info from the same module
%%		works. This seems trivial, but the problem is that the
%%		module_info/[0,1] functions that the BEAM file contains
%%		are dummy functions containing crap. So, these functions
%%		cannot be used for compilation to native code and the
%%		functions that the BEAM loader generates should be used
%%		instead. This was a HiPE bug reported by Dan Wallin.
%%  History  :  * 2003-10-25 Kostis Sagonas (kostis@csd.uu.se): Created.
%% CVS:
%%    $Author: kostis $
%%    $Date: 2003/10/26 11:22:43 $
%%    $Revision: 1.1 $
%% ====================================================================
%% Exported functions (short description):
%%  test()         - execute the test.
%%  compile(Flags) - Compile to native code with compiler flags Flags.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-module(simpl_mi).
-export([test/0,compile/1]).

test() ->
  L = test_local_mi0_call(),
  E = test_remote_mi1_call(),
  {{local,L},{external,E}}.

test_local_mi0_call() ->
  ModInfo = module_info(),
  %% io:format("ok, ModInfo=~w\n", [ModInfo]),
  {value, {exports, FunList}} = lists:keysearch(exports, 1, ModInfo),
  length(FunList).

test_remote_mi1_call() ->
  FunList = ?MODULE:module_info(exports),
  length(FunList).

compile(Flags) ->
  hipe:c(?MODULE,Flags).
