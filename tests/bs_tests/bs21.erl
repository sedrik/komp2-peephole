%%%-------------------------------------------------------------------
%%% File : bs21.erl 
%%% Author : Per Gustafsson <pergu@it.uu.se>
%%% Description : Build a big enough binary to have a bit size that
%%%               needs a bignum on 32-bit architectures
%%%
%%% Created : 26 Nov 2007 by Per Gustafsson <pergu@hamberg.it.uu.se>
%%%-------------------------------------------------------------------
-module(bs21).

-export([test/0, compile/1]).

compile(O) ->
  hipe:c(?MODULE,O).

test() ->
  16#10000008 = erlang:bit_size(build_binary(1,2,3,4)),
  ok.

build_binary(X1,X2,X3,X4) ->
  << 1, <<X1:(16#4000000),
	 X2:(16#4000000),
	 X3:(16#4000000),
	 X4:(16#4000000)>>/bits >>.
