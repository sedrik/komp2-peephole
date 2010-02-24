%%-------------------------------------------------------------------
%% File    : fp_beam_bug.erl
%% Purpose : Test which shows that BEAM's splitting of basic blocks
%%	     should take into account that arithmetic operations
%%	     implemented as bifs can also cause exceptions and thus
%%	     calls to bifs should end basic blocks.
%%	     The problem was preliminary fixed on April 6th and
%%	     the fix  was extended by Bjorn G. on April 7th.
%%
%% Created : 6 April 2004 by Kostis S. (after a mail by Mikael P.)
%%-------------------------------------------------------------------

-module(fp_beam_bug).
-export([test/0,compile/1]).

test() ->
  {t1(), t2()}.

t1() ->
  X = (catch bad_arith1(2.0, 1.7)),
  case X of
    {'EXIT', {badarith, _}} ->
      ok;
    _ ->
      error
  end.

bad_arith1(X, Y) when is_float(X) ->
  X1 = X * 1.7e+308,
  X2 = X1 + 1.0,
  Y1 = Y * 2,
  {X2, Y1}.


%% Similarly, it is not kosher to have anything that can fail inside
%% the fp block since it will throw the exception before the fp
%% exception and we will get the same problems.

t2() ->
  case catch bad_arith2(2.0, []) of
    {'EXIT', {badarith, _}} ->
      ok;
    _ ->
      error
  end.

bad_arith2(X, Y) when is_float(X) ->
  X1 = X * 1.7e+308,
  Y1 = element(1, Y),
  {X1 + 1.0, Y1}.


compile(O) ->
  hipe:c(?MODULE,O).
