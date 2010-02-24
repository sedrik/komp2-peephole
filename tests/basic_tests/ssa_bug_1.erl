%% ====================================================================
%% Test module for the HiPE test suite.
%%
%%  Filename : 	ssa_bug_1.erl
%%  Module   :	ssa_bug_1
%%  Purpose  :  Expose a bug in the generation of dominance trees used in ssa.
%%  History  :	* 2003/06/11 Tobias Lindahl (tobiasl@csd.uu.se): Created.
%% CVS:
%%    $Author: tobiasl $
%%    $Date: 2003/06/11 15:06:41 $
%%    $Revision: 1.1 $
%% ====================================================================
%% Exported functions (short description):
%%  test()         - execute the test.
%%  compile(Flags) - Compile to native code with compiler flags Flags.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-module(ssa_bug_1).
-export([test/0, doit/2, compile/1]).

-record(state,{something}).

doit(Foo, S) ->
  Fee = 
    case Foo of
      Bar when Bar == S#state.something; Bar == [] ->
	true;
      _ ->
	false
    end,
  {ok, Fee}.

test()->
  {ok, true} = doit(true, #state{something=true}),
  ok.

compile(Flags) ->
    hipe:c(?MODULE,Flags).
