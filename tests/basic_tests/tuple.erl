%% Copyright (c) 1999 by Erik Johansson.  All Rights Reserved 
%% Time-stamp: <99/12/16 11:53:21 happi>
%% ====================================================================
%%  Filename : 	tuple.erl
%%  Module   :	tuple
%%  Purpose  :  
%%  Notes    : 
%%  History  :	* 1999-12-03 Erik Johansson (happi@csd.uu.se): Created.
%% CVS:
%%    $Author: kostis $
%%    $Date: 2003/12/17 00:54:48 $
%%    $ $
%% ====================================================================
%% Exported functions (short description):
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-module(tuple).
-export([test/0,compile/1]).

test() ->
    test_element([]).

test_element(N) ->
    element(1,catch element(N,{1,2,3,4,5,6,7,8,9,10,11})).

compile(Flags) ->
    hipe:c(?MODULE,Flags).
