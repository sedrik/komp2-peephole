%% ====================================================================
%% Test module for the HiPE test suite.
%%
%%  Filename : 	simpl_sv.erl
%%  Purpose  :  Tests switch_val instruction.
%%  History  :	* Oct 25, 2000 (kostis@csd.uu.se): Created.
%% CVS:
%%    $Author: kostis $
%%    $Date: 2001/02/13 16:49:25 $
%%    $Revision: 1.2 $
%% ====================================================================
%% Exported functions (short description):
%%  test()         - execute the test.
%%  compile(Flags) - Compile to native code with compiler flags Flags.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-module(simpl_sv).
-export([test/0,compile/1]).

test() ->
    {sv(a),sv(b),sv(c),sv(d)}.

compile(Flags) ->
    hipe:c(?MODULE,Flags).

sv(a) -> 'A';
sv(b) -> 'B';
sv(c) -> 'C';
sv(_) -> foo.
