%% Copyright (c) 1999 by Erik Johansson.  All Rights Reserved 
%% Time-stamp: <2001-03-22 18:41:28 richardc>
%% ====================================================================
%% Test module for the HiPE test suite.
%%
%%  Filename : trivial_14.erl
%%  Module   : trivial_14
%%  Purpose  :  
%%  Notes    : 
%%  History  : 1999-12-05 Erik Johansson (happi@csd.uu.se): Created.
%% CVS:
%%    $Author: kostis $
%%    $Date: 2002/05/07 13:06:34 $
%%    $ $
%% ====================================================================
%% Exported functions (short description):
%%  test()         - execute the test.
%%  compile(Flags) - Compile to native code with compiler flags Flags.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-module(trivial_14).
-export([test/0,compile/1]).

test() ->
    first(42,true).

first(X,_) ->
    (X * X) div X.

compile(Flags) ->
    hipe:c({?MODULE,test,0},Flags).
