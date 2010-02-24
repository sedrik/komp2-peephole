%% ====================================================================
%% Test module for the HiPE test suite.
%%
%%  Filename : 	test03.erl
%%  Module   :	test03
%%  Purpose  :  Test compilation of boolean primitives.
%% CVS:
%%    $Id: test03.erl,v 1.2 2004/01/27 15:11:44 kostis Exp $
%% ====================================================================
%% Exported functions (short description):
%%  test()         - execute the test.
%%  compile(Flags) - Compile to native code with compiler flags Flags.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-module(test03).
-export([test/0,compile/1]).

test() ->
    F = false,
    T = true,
    test(F,T).

test(F,T) ->
    true  = T and T,
    false = T and F,
    false = F and T,
    false = F and F,
    true  = T or T,
    true  = T or F,
    true  = F or T,
    false = F or F,
    true  = T andalso T,
    false = T andalso F,
    false = F andalso T,
    false = F andalso F,
    true  = T orelse T,
    true  = T orelse F,
    true  = F orelse T,
    false = F orelse F,
    ok.

compile(Flags) ->
    hipe:c(test03,Flags).
