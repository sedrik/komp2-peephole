%% Copyright (c) 1999 by Erik Johansson.  All Rights Reserved 
%% Time-stamp: <99/12/03 15:00:37 happi>
%% ====================================================================
%%  Filename : 	small.erl
%%  Module   :	small
%%  Purpose  :  
%%  Notes    : 
%%  History  :	* 1999-12-02 Erik Johansson (happi@csd.uu.se): Created.
%% CVS:
%%    $Author: kostis $
%%    $Date: 2001/02/13 16:49:25 $
%%    $ $
%% ====================================================================
%% Exported functions (short description):
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-module(small).
-export([compile/1,test/0]).

test_catch() ->
    {catch exit(exit_test),catch throw(throw_test)}.

not_eq(A,B) ->
    A =/= B.

two() -> ((1 bsl 11) bor 2) band 16#3ff.

test() ->
    {test_catch(),not_eq(2,two())}.

compile(Flags) ->
    hipe:c(small,Flags).
