%% Copyright (c) 1999 by Erik Johansson.  All Rights Reserved 
%% Time-stamp: <99/12/06 13:57:37 happi>
%% ====================================================================
%% Test module for the HiPE test suite.
%%
%%  Filename : 	test07.erl
%%  Module   :	test07
%%  Purpose  :  Forces floating point exceptions and tests that subsequent, 
%%              legal, operations are calculated correctly.  
%% 
%%  Notes    : Original version by Sebastian Strollo.
%%             Second version by 'bjorn@erix.ericsson.se'
%%  History  :	* 1999-12-05 Erik Johansson (happi@csd.uu.se): Created.
%% CVS:
%%    $Author: kostis $
%%    $Date: 2009/01/18 19:03:11 $
%%    $ $
%% ====================================================================
%% Exported functions (short description):
%%  test()         - execute the test.
%%  compile(Flags) - Compile to native code with compiler flags Flags.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-module(test07).
-export([test/0,compile/1]).

test() ->
    0.0 = math:log(1.0),
    {'EXIT', _} = (catch math:log(minus_one_float())),
    0.0 = math:log(1.0),
    {'EXIT', _} = (catch math:log(zero_float())),
    0.0 = math:log(1.0),
    {'EXIT',_} = (catch r_mult(3.23e133,3.57e257)),
    0.0 = math:log(1.0),
    {'EXIT',_} = (catch r_div(5.0,0.0)),
    0.0 = math:log(1.0),
    ok.

r_mult(X,Y) ->
    X * Y.

r_div(X,Y) ->
    X / Y.

%% The following two functions appear just to shut off 'expression will
%% fail with a badarg' warnings from the BEAM compiler
zero_float() -> 0.0.
minus_one_float() -> -1.0.

compile(Flags) ->
    hipe:c(?MODULE,Flags).
