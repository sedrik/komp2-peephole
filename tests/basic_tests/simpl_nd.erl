%% ====================================================================
%% Test module for the HiPE test suite.
%%
%%  Filename : 	simpl_nd.erl
%%  Module   :	simpl_nd
%%  Purpose  :  Tests whether the translation of some guards works.
%%  History  :	* 2000-10-25 Kostis Sagonas (kostis@csd.uu.se): Created.
%% CVS:
%%    $Author: richardc $
%%    $Date: 2004/10/27 21:51:27 $
%%    $Revision: 1.5 $
%% ====================================================================
%% Exported functions (short description):
%%  test()         - execute the test.
%%  compile(Flags) - Compile to native code with compiler flags Flags.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-module(simpl_nd).
-export([test/0,compile/1]).

test() ->
%%     {IfExit,{If2,[If3|_IfRest]}} = (catch if_end_error()),
    {IfExit,{If2,_Trace1}} = (catch if_end_error()),
%%     {CaseExit,{Case2,[Case3|_CaseRest]}} = (catch case_end_error()),
    {CaseExit,{Case2,_Trace2}} = (catch case_end_error()),
%%     If = {IfExit,{If2,[If3]}},
    If = {IfExit,If2},
%%     Case = {CaseExit,{Case2,[Case3]}},
    Case = {CaseExit,Case2},
    [If,Case].

if_end_error() ->
    Zero = zero(),
    if 42 < Zero ->
	    ok
    end.

zero() ->
    0.

case_end_error() ->
    case the_answer() of
	17 -> weird
    end.

the_answer() ->
    42.

compile(Flags) ->
    hipe:c(?MODULE,Flags).
