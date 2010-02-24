%%%-------------------------------------------------------------------
%%% File    : bs16.erl
%%% Author  : Per Gustafsson <pergu@it.uu.se>
%%% Description : This tests comes from orber, it makes sure that labels 
%%%               are handled properly from core.
%%%
%%% Created :  2 Nov 2004 by Per Gustafsson <pergu@it.uu.se>
%%%-------------------------------------------------------------------
-module(bs16).

-export([test/0,compile/1]).

test() ->
  A=dec_giop_message_header(<<1,1:32/little-integer>>),
  B=dec_giop_message_header(<<0,1:32/big-integer>>),
  C=dec_giop_message_header(<<2,1:32/little-integer>>),
  D=dec_giop_message_header(<<3,1:32/big-integer>>),
  {A,B,C,D}.

compile(O) ->
  hipe:c(?MODULE,O).
  
dec_giop_message_header(<<1:8,
			MessSize:32/little-integer>>) ->
    {MessSize};
dec_giop_message_header(<<0:8,
			MessSize:32/big-integer>>) ->
    {MessSize};
dec_giop_message_header(<<Flags:8,
			MessSize:32/little-integer>>) when
  ((Flags band 16#03) == 16#02) ->
   {Flags, MessSize};
dec_giop_message_header(<<Flags:8,
			MessSize:32/big-integer>>) ->
    {Flags, MessSize}.
