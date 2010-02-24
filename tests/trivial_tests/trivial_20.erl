%% Copyright (c) 1999 by Erik Johansson.  All Rights Reserved 
%% Time-stamp: <2004-10-27 22:34:34 richardc>
%% ====================================================================
%% Test module for the HiPE test suite.
%%
%%  Filename : 	trivial_20.erl
%%  Module   :	trivial_20
%%  Purpose  :  
%%  Notes    : 
%%  History  :	* 30/7/2001 Kostis Sagonas (kostis@csd.uu.se): Created.
%% CVS:
%%    $Author: richardc $
%%    $Date: 2004/10/27 21:51:27 $
%%    $ $
%% ====================================================================
%% Exported functions (short description):
%%  test()         - execute the test.
%%  compile(Flags) - Compile to native code with compiler flags Flags.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-module(trivial_20).
-export([test/0,compile/1]).

test() ->
%%   {'EXIT',{{badmatch,b},[{?MODULE,F1,0}|_]}} = (catch badmatch()),
  {'EXIT',{{badmatch,b},_Trace1}} = (catch badmatch()),
%%   {'EXIT',{{badmatch,b},[{?MODULE,F2,0}|_]}} = (catch inline_catch_badmatch()),
  {'EXIT',{{badmatch,b},_Trace2}} = (catch inline_catch_badmatch()),
%%   {badmatch,inline_catch_badmatch} = {F1,F2},
  ok.

badmatch() ->
  a = b().

inline_catch_badmatch() ->
  catch a = b().

b() ->
  b.

compile(Flags) ->
  hipe:c(?MODULE,Flags).
