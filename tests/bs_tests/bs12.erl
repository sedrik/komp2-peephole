%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Copyright (c) 2001 by Erik Johansson.  All Rights Reserved 
%% Time-stamp: <01/06/14 13:34:19 happi>
%% ====================================================================
%%  Filename : 	bs12.erl
%%  Module   :	bs12
%%  Purpose  :  
%%  Notes    : 
%%  History  :	* 2001-06-14 Erik Johansson (happi@csd.uu.se): 
%%               Created.
%%  CVS      :
%%              $Author: kostis $
%%              $Date: 2007/08/16 14:15:06 $
%%              $Revision: 1.3 $
%% ====================================================================
%%  Exports  :
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-module(bs12).

-export([test/0,compile/1]).


compile(O) ->
  hipe:c(?MODULE,O).

test() ->
  {aligned(),
   unaligned(),
   zero_tail()}.

aligned() ->
     Tail1 = mkbin([]),
     {258,Tail1} = al_get_tail_used(mkbin([1,2])),
     Tail2 = mkbin(lists:seq(1, 127)),
     {35091,Tail2} = al_get_tail_used(mkbin([137,19|Tail2])),
     64896 = al_get_tail_unused(mkbin([253,128])),
     64895 = al_get_tail_unused(mkbin([253,127|lists:seq(42, 255)])),
     Tail3 = mkbin(lists:seq(0, 19)),
     {0,Tail1} = get_dyn_tail_used(Tail1, 0),
     {0,Tail3} = get_dyn_tail_used(mkbin([Tail3]), 0),
     {73,Tail3} = get_dyn_tail_used(mkbin([73|Tail3]), 8),

     0 = get_dyn_tail_unused(mkbin([]), 0),
     233 = get_dyn_tail_unused(mkbin([233]), 8),
     23 = get_dyn_tail_unused(mkbin([23,22,2]), 8),
    ok.

al_get_tail_used(<<A:16,T/binary>>) -> {A,T}.
al_get_tail_unused(<<A:16,_/binary>>) -> A.

unaligned()->
     {'EXIT',{function_clause,_}} = (catch get_tail_used(mkbin([42]))),
     {'EXIT',{{badmatch,_},_}} = (catch get_dyn_tail_used(mkbin([137]), 3)),
     {'EXIT',{function_clause,_}} = (catch get_tail_unused(mkbin([42,33]))),
     {'EXIT',{{badmatch,_},_}} = (catch get_dyn_tail_unused(mkbin([44]), 7)),
    ok.

get_tail_used(<<A:1,T/binary>>) -> {A,T}.

get_tail_unused(<<A:15,_/binary>>) -> A.

get_dyn_tail_used(Bin, Sz) ->
    <<A:Sz,T/binary>> = Bin,
    {A,T}.

get_dyn_tail_unused(Bin, Sz) ->
    <<A:Sz,_T/binary>> = Bin,
    A.

zero_tail()->
     7 = (catch test_zero_tail(mkbin([7]))),
     {'EXIT',{function_clause,_}} = (catch test_zero_tail(mkbin([1,2]))),
     {'EXIT',{function_clause,_}} = (catch test_zero_tail2(mkbin([1,2,3]))),
    ok.

test_zero_tail(<<A:8>>) -> A.

test_zero_tail2(<<_:4,_:4>>) -> ok.

mkbin(L) when is_list(L) -> list_to_binary(L).
