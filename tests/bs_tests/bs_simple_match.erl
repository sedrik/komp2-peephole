%%% -*- erlang-indent-level: 2 -*-
%%%-------------------------------------------------------------------
%%% File : bs_simple_match.erl 
%%% Author : Per Gustafsson <pergu@fan.it.uu.se> 
%%% Description : A module which performs simple
%%%               matching and construction of binaries
%%%
%%%  TODO: Add binary and float tests
%%% Created : 20 Feb 2004 by Per Gustafsson <pergu@fan.it.uu.se>
%%%-------------------------------------------------------------------
-module(bs_simple_match).

-export([test/0,compile/1]).

compile(O) ->
  hipe:c(?MODULE,O).

test() ->
  10 = aligned_skip_bits_all(1, <<10, 11, 12>>),
  10 = unaligned_skip_bits_all(8, <<10, 11, 12>>),
  test_static_integer_matching_1(),
  test_static_integer_matching_2(),
  test_static_integer_matching_3(),
  test_static_integer_matching_4(),
  test_dynamic_integer_matching(28),
  test_dynamic_integer_matching(27),
  test_dynamic_integer_matching(9),
  test_dynamic_integer_matching(17),
  test_dynamic_integer_matching(25),
  test_dynamic_integer_matching(8),
  test_dynamic_integer_matching(16),
  test_dynamic_integer_matching(24),
  test_dynamic_integer_matching(32),
  ok.

test_dynamic_integer_matching(N) ->
  S = 32-N,
  <<-12:N/integer-signed, 0:S>> = << -12:N/integer-signed, 0:S>>,
  <<-12:N/integer-little-signed, 0:S>> = << -12:N/integer-little-signed, 0:S>>,
  <<12:N/integer, 0:S>> = << 12:N/integer, 0:S>>,
  <<12:N/integer-little, 0:S>> = << 12:N/integer-little, 0:S>>.

test_static_integer_matching_1() ->
  <<0:6, -25:28/integer-signed, 0:6>> =  <<0:6, -25:28/integer-signed, 0:6>>,
  <<0:6, -25:28/integer-little-signed, 0:6>> =  
    <<0:6, -25:28/integer-little-signed, 0:6>>,
  <<0:6, 25:28/integer-little, 0:6>> =  
    <<0:6, 25:28/integer-little, 0:6>>,
  <<0:6, 25:28, 0:6>> =  
    <<0:6, 25:28, 0:6>>.

test_static_integer_matching_2() ->
  <<0:6, -25:20/integer-signed, 0:6>> =  <<0:6, -25:20/integer-signed, 0:6>>,
  <<0:6, -25:20/integer-little-signed, 0:6>> =  
    <<0:6, -25:20/integer-little-signed, 0:6>>,
  <<0:6, 25:20/integer-little, 0:6>> =  
    <<0:6, 25:20/integer-little, 0:6>>,
  <<0:6, 25:20, 0:6>> =  
    <<0:6, 25:20, 0:6>>.

test_static_integer_matching_3() ->
  <<0:6, -25:12/integer-signed, 0:6>> =  <<0:6, -25:12/integer-signed, 0:6>>,
  <<0:6, -25:12/integer-little-signed, 0:6>> =  
    <<0:6, -25:12/integer-little-signed, 0:6>>,
  <<0:6, 25:12/integer-little, 0:6>> =  
    <<0:6, 25:12/integer-little, 0:6>>,
  <<0:6, 25:12, 0:6>> =  
    <<0:6, 25:12, 0:6>>.

test_static_integer_matching_4() ->
  <<0:6, -3:4/integer-signed, 0:6>> =  <<0:6, -3:4/integer-signed, 0:6>>,
  <<0:6, -3:4/integer-little-signed, 0:6>> =  
    <<0:6, -3:4/integer-little-signed, 0:6>>,
  <<0:6, 7:4/integer-little, 0:6>> =  
    <<0:6, 7:4/integer-little, 0:6>>,
  <<0:6, 7:4, 0:6>> =  
    <<0:6, 7:4, 0:6>>.


aligned_skip_bits_all(N, Bin) ->
  <<X:N/integer-unit:8, _/binary>> = Bin,
  X.

unaligned_skip_bits_all(N, Bin) ->
  <<X:N, _/binary>> = Bin,
  X.

