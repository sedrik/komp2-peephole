%% Copyright (c) 1999 by Erik Johansson.  All Rights Reserved 
%% Time-stamp: <99/12/08 16:53:47 happi>
%% ====================================================================
%% Test module for the HiPE test suite.
%%
%%  Filename : 	test08.erl
%%  Module   :	test08
%%  Purpose  :  Test guard expressions.
%%  Notes    :  Original by bjorn@erix.ericsson.se
%%  History  :	* 1999-12-05 Erik Johansson (happi@csd.uu.se): Created.
%% CVS:
%%    $Author: kostis $
%%    $Date: 2009/03/10 17:47:29 $
%%    $Revision: 1.3 $
%% ====================================================================
%% Exported functions (short description):
%%  test()         - execute the test.
%%  compile(Flags) - Compile to native code with compiler flags Flags.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-module(test08).
-export([test/0,compile/1,bad_arith/0,bad_tuple/0,strange_guard/0]).

test() ->
    {bad_arith(),bad_tuple(),strange_guard()}.

compile(Flags) ->
    hipe:c(?MODULE,Flags).


bad_arith() ->
    5 = bad_arith1(2, 3),
    10 = bad_arith1(1, infinity),
    10 = bad_arith1(infinity, 1),
    10 = bad_arith2(infinity, 1),
    10 = bad_arith3(inf),
    10 = bad_arith4(infinity, 1),
    ok.

bad_arith1(T1, T2) when T1+T2 < 10 ->
    T1+T2;
bad_arith1(_, _) ->
    10.

bad_arith2(T1, T2) when T1*T2 < 10 ->
    T1*T2;
bad_arith2(_, _) ->
    10.

bad_arith3(T) when bnot T < 10 ->
    T;
bad_arith3(_) ->
    10.

bad_arith4(T1, T2) when T1 bsr T2 < 10 ->
    T1*T2;
bad_arith4(_, _) ->
    10.

bad_tuple() ->
    error = bad_tuple1(a),
    error = bad_tuple1({a, b}),
    x = bad_tuple1({x, b}),
    y = bad_tuple1({a, b, y}),
    ok.

bad_tuple1(T) when element(1, T) == x ->
    x;
bad_tuple1(T) when element(3, T) == y ->
    y;
bad_tuple1(_) ->
    error.

strange_guard() when is_tuple({1,2,length([1,2,3,5]),self()}) ->
    true;
strange_guard() ->
    false.
