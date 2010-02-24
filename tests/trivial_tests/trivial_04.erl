%% Copyright (c) 1999 by Erik Johansson.  All Rights Reserved 
%% Time-stamp: <2001-03-22 18:40:35 richardc>
%% ====================================================================
%% Test module for the HiPE trivial test suite.
%%
%%  Filename : trivial_04.erl
%%  Module   : trivial_04
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

-module(trivial_04).
-export([test/0,compile/1]).

test() ->
  first(42,true).

first(X,_) ->
  X.

compile(Flags) ->
  hipe:c({?MODULE,first,2},Flags).
