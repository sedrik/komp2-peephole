%% Copyright (c) 1999 by Erik Johansson.  All Rights Reserved 
%% Time-stamp: <99/12/06 12:21:49 happi>
%% ====================================================================
%% Test module for the HiPE test suite.
%%
%%  Filename : 	test05.erl
%%  Module   :	test05
%%  Purpose  :  
%%  Notes    : 
%%  History  :	* 1999-12-05 Erik Johansson (happi@csd.uu.se): Created.
%% CVS:
%%    $Author: kostis $
%%    $Date: 2001/02/13 16:49:25 $
%%    $ $
%% ====================================================================
%% Exported functions (short description):
%%  test()         - execute the test.
%%  compile(Flags) - Compile to native code with compiler flags Flags.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-module(test05).
-export([test/0,compile/1]).

test() ->
    {
      {98765432101234 div 98765432101235,0},
      {339254531512 div 68719476736,4},
      {4722366482869645213696 div 68719476736,68719476736},
      {68719476736,68719476736,4722366482869645213696},
      {round(98765432101234 / 98765432101235),1},
      {round(339254531512 / 68719476736),5},
      {round(339254531512 - (339254531512 / 68719476736) *  68719476736),0}
     }.

compile(Flags) ->
    hipe:c(?MODULE,Flags).
