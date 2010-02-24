%% ====================================================================
%% Test module for the HiPE test suite.
%%
%%  Filename : 	simpl_bn.erl
%%  Module   :	simpl_bn
%%  Purpose  :  Tests whether bignums work.
%%  History  :	* 2000-11-1 Kostis Sagonas (kostis@csd.uu.se): Created.
%% CVS:
%%    $Author: kostis $
%%    $Date: 2001/02/13 16:49:25 $
%%    $Revision: 1.2 $
%% ====================================================================
%% Exported functions (short description):
%%  test()         - execute the test.
%%  compile(Flags) - Compile to native code with compiler flags Flags.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-module(simpl_bn).
-export([test/0,compile/1]).

test() ->
    {factorial,42,fac(42)}.

fac(0) ->
    1;
fac(N) ->
    N * fac(N-1).

compile(Flags) ->
    hipe:c(?MODULE,Flags).
