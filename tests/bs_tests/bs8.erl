%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Copyright (c) 2001 by Erik Johansson.  All Rights Reserved 
%% Time-stamp: <2004-08-20 17:08:27 richardc>
%% ====================================================================
%%  Filename : 	bs.erl
%%  Module   :	bs
%%  Purpose  :  
%%  Notes    : 
%%  History  :	* 2001-04-10 Erik Johansson (happi@csd.uu.se): 
%%               Created.
%%  CVS      :
%%              $Author: kostis $
%%              $Date: 2007/08/16 14:15:06 $
%%              $Revision: 1.7 $
%% ====================================================================
%%  Exports  :
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-module(bs8).
-export([test/0,compile/1]).

-define(FAIL(Expr), {'EXIT',{badarg,_}} = (catch Expr)).

compile(O) ->
  hipe:c(?MODULE,O).

test()->
  {byte_split_binary(),
   bit_split_binary()}.

byte_split_binary() ->
  L = lists:seq(0, 57),
  B = mkbin(L),
  byte_split(L, B, size(B)).

byte_split(L, B, Pos) when Pos >= 0 ->
  Sz1 = Pos,
  Sz2 = size(B) - Pos,
  bs1(L, B, Pos, Sz1, Sz2);
byte_split(_, _, _) -> ok.

bs1(L, B, Pos, Sz1, Sz2) ->
  <<B1:Sz1/binary,B2:Sz2/binary>> = B,
  bs2(L, B, Pos, B1, B2).

bs2(L, B, Pos, B1, B2)->
  B1 = list_to_binary(lists:sublist(L, 1, Pos)),
  bs3(L, B, Pos, B2).

bs3(L, B, Pos, B2) ->
  B2 = list_to_binary(lists:nthtail(Pos, L)),
  byte_split(L, B, Pos-1).

bit_split_binary() ->
  Fun = fun(Bin, List, SkipBef, N) ->
	    SkipAft = 8*size(Bin) - N - SkipBef,
	    %% io:format("~p, ~p, ~p", [SkipBef,N,SkipAft]),
	    <<_I1:SkipBef,OutBin:N/binary-unit:1,_I2:SkipAft>> = Bin,
	    OutBin = make_bin_from_list(List, N)
	end,
  bit_split_binary1(Fun, erlang:md5(<<1,2,3>>)),
  ok.

bit_split_binary1(Action, Bin) ->
  BitList = bits_to_list(binary_to_list(Bin), 16#80),
  bit_split_binary2(Action, Bin, BitList, 0).

bit_split_binary2(Action, Bin, [_|T]=List, Bef) ->
  bit_split_binary3(Action, Bin, List, Bef, size(Bin)*8),
  bit_split_binary2(Action, Bin, T, Bef+1);
bit_split_binary2(_Action, _Bin, [], _Bef) -> ok.

bit_split_binary3(Action, Bin, List, Bef, Aft) when Bef =< Aft ->
  Action(Bin, List, Bef, (Aft-Bef) div 8 * 8),
  bit_split_binary3(Action, Bin, List, Bef, Aft-8);
bit_split_binary3(_, _, _, _, _) -> ok.

make_bin_from_list(_List, 0) ->
  mkbin([]);
make_bin_from_list(List, N) ->
  list_to_binary([make_int(List, 8, 0),
		  make_bin_from_list(lists:nthtail(8, List), N-8)]).


make_int(_List, 0, Acc) -> Acc;
make_int([H|T], N, Acc) -> make_int(T, N-1, Acc bsl 1 bor H).
    
bits_to_list([_|T], 0) -> bits_to_list(T, 16#80);
bits_to_list([H|_]=List, Mask) ->
  [case H band Mask of
     0 -> 0;
     _ -> 1
   end|bits_to_list(List, Mask bsr 1)];
bits_to_list([], _) -> [].

mkbin(L) when is_list(L) -> list_to_binary(L).
