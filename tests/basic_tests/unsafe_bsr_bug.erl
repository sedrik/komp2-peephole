%%% -*- erlang-indent-level: 2 -*-
%%% $Id: unsafe_bsr_bug.erl,v 1.1 2006/12/10 22:44:05 mikpe Exp $
%%% In October 2006 the HiPE compiler acquired more type-driven
%%% optimisations of arithmetic operations. One of these, the
%%% transformation of bsr to a pure fixnum bsr fixnum -> fixnum
%%% version (unsafe_bsr), failed to check for shifts larger than
%%% the number of bits in fixnums. Such shifts should return zero,
%%% but instead they became plain machine-level shift instructions.
%%% Machines often only consider the low-order bits of the shift
%%% count, so machine-level shifts larger than the word size do not
%%% match the Erlang semantics.
-module(unsafe_bsr_bug).
-export([test/0, compile/1]).

test() ->
  check(test_cases()).

compile(Opts) ->
  hipe:c(?MODULE, Opts).

test_cases() ->
  [{16#FF,4,16#0F},
   {16#FF,64,0}].

check([]) -> ok;
check([{X,Y,Z}|Rest]) ->
  case do_bsr(X, Y) of
    Z -> check(Rest);
    _ -> 'hipe_broke_bsr'
  end.

do_bsr(X, Y) -> (X band 16#FFFF) bsr (Y band 16#FFFF).
