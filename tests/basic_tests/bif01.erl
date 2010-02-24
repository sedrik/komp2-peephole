%% ====================================================================
%% Test module for the HiPE test suite.
%%
%%  Filename : 	bif01.erl
%%  Module   :	bif01
%%  Purpose  :  Tests handling of bifs in guards and elsewhere.
%%  History  :	* 2000/10/24 Kostis Sagonas (kostis@csd.uu.se): Created.
%% CVS:
%%    $Author: kostis $
%%    $Date: 2001/02/13 16:49:25 $
%%    $Revision: 1.2 $
%% ====================================================================
%% Exported functions (short description):
%%  test()         - execute the test.
%%  compile(Flags) - Compile to native code with compiler flags Flags.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-module(bif01).
-export([test/0,compile/1,ba/1]).

ba(T) when element(1,T) == a ->
    element(2,T) == b;
ba(_) ->
    ok.

test() ->
    {ba({a,b}),ba({a,c}),ba(foo)}.

compile(Flags) ->
    hipe:c(?MODULE,Flags).

