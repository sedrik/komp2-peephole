%% ====================================================================
%% Test module for the HiPE test suite.
%%
%%  Filename : 	simpl_cs.erl
%%  Module   :	simpl_cs
%%  Purpose  :  Tests whether all labels of a function are local.
%%  History  :	* 2000-10-29 Kostis Sagonas (kostis@csd.uu.se): Created.
%% CVS:
%%    $Author: kostis $
%%    $Date: 2001/02/13 16:49:25 $
%%    $Revision: 1.2 $
%% ====================================================================
%% Exported functions (short description):
%%  test()         - execute the test.
%%  compile(Flags) - Compile to native code with compiler flags Flags.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-module(simpl_cs).
-export([test/0,compile/1]).

test() ->
    s(42).

compile(Flags) ->
    hipe:c(?MODULE,Flags).

s(Key) ->
    case foo(Key) of
	17.1345 ->
	    really_weird;
	Other ->
	    exit({correct_result,Other})
    end.

foo(X) ->
    X.
