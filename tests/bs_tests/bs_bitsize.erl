-module(bs_bitsize).
-export([test/0, compile/1]).

-compile(bitlevel_binaries).

test() ->
  true = bitsize_in_body(<<1:42>>),
  true = bitsize_in_guard(<<1:7>>),
  8 = constant_binary(42),
  ok.

bitsize_in_body(Bin) ->
  42 =:= erlang:bit_size(Bin).

bitsize_in_guard(Bin) when erlang:bit_size(Bin) rem 7 =:= 0 ->
  true;
bitsize_in_guard(Bin) when is_binary(Bin) ->
  false.

constant_binary(N) when N > 0 ->
  bit_size(<<42>>).

compile(Opts) ->
  hipe:c(?MODULE, Opts).
