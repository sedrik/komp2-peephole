%%%-------------------------------------------------------------------
%%% File    : bs19.erl
%%% Author  : Per Gustafsson <pergu@jobberl>
%%% Description : Tests that compilation works for bs_save
%%%
%%% Created :  1 Nov 2007 by Per Gustafsson <pergu@jobberl>
%%%-------------------------------------------------------------------
-module(bs19).

-export([test/0, compile/1]).

compile(O) ->
  hipe:c(?MODULE,O).

test() ->
  {[16257,1],<<0>>} = 
    inc_on_ones(<<255,1,128,1,128,0>>, 0, [], 5),
  ok.


inc_on_ones(Buffer, _Av, Al, 0) -> 
    {lists:reverse(Al),Buffer}; 
inc_on_ones(<<1:1,H:7,T/binary>>, Av, Al, Len) -> 
    inc_on_ones(T, (Av bsl 7) bor H, Al, Len-1);
inc_on_ones(<<H,T/binary>>, Av, Al, Len) -> 
    inc_on_ones(T, 0, [((Av bsl 7) bor H)|Al], Len-1).
