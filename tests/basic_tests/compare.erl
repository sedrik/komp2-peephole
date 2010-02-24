%% -*- erlang-indent-level: 2 -*-
%% ====================================================================
%%  Filename :  compare.erl
%%  Purpose  :  Checks correct handling of comparison operators.
%%  History  :  2006-07-24 Kostis Sagonas (kostis@it.uu.se): Created.
%%
%% CVS:
%%    $Author: kostis $
%%    $Date: 2007/11/02 07:59:19 $
%%    $Revision: 1.2 $
%% ====================================================================

-module(compare).
-export([test/0,compile/1]).
%% -export([is_zero_int/1, is_zero_num/1]).
%% -export([is_nonzero_int/1, is_nonzero_num/1]).
%% -export([is_foo_exact/1, is_foo_term1/1, is_foo_term2/1]).
%% -export([is_bin_exact/1, is_bin_term1/1, is_bin_term2/1]).

test() ->
  { true,false, true} = {dummy_eq_num(), dummy_eq_exact(), dummy_ne_exact()},
  { true,false,false} = {is_zero_int(0), is_zero_int(1), is_zero_int(0.0)},
  { true,false, true} = {is_zero_num(0), is_zero_num(1), is_zero_num(0.0)},
  {false, true, true} = {is_nonzero_int(0), is_nonzero_int(1), is_nonzero_int(0.0)},
  {false, true,false} = {is_nonzero_num(0), is_nonzero_num(1), is_nonzero_num(0.0)},
  { true, true, true} = {is_foo_exact(foo), is_foo_term1(foo), is_foo_term2(foo)},
  {false,false,false} = {is_foo_exact(bar), is_foo_term1(bar), is_foo_term2(bar)},
  {false,false,false} = {is_nonfoo_exact(foo), is_nonfoo_term1(foo), is_nonfoo_term2(foo)},
  { true, true, true} = {is_nonfoo_exact(bar), is_nonfoo_term1(bar), is_nonfoo_term2(bar)},
  Tup = {a,{42},[c]},
  { true, true, true} = {is_tuple_skel(Tup), is_tuple_exact(Tup), is_tuple_term(Tup)},
  B42 = <<42>>,
  B42 = <<42>>,
  { true, true, true} = {is_bin_exact(B42), is_bin_term1(B42), is_bin_term2(B42)},
  B42f = <<42/float>>,
  {false,false,false} = {is_bin_exact(B42f), is_bin_term1(B42f), is_bin_term2(B42f)},
  ok.

%%---------------------------------------------------------------------

dummy_eq_num() -> 1 == 1.0.

dummy_eq_exact() -> 1 =:= 1.0.

dummy_ne_exact() -> 1 =/= 1.0.

%%---------------------------------------------------------------------

is_zero_int(N) when N =:= 0 -> true;
is_zero_int(_) -> false.

is_zero_num(N) when N == 0 -> true;
is_zero_num(_) -> false.

%%---------------------------------------------------------------------

is_nonzero_int(N) when N =/= 0 -> true;
is_nonzero_int(_) -> false.

is_nonzero_num(N) when N /= 0 -> true;
is_nonzero_num(_) -> false.

%%---------------------------------------------------------------------
%% There should not really be any difference in the generated code
%% for the following three functions.

is_foo_exact(A) when A =:= foo -> true;
is_foo_exact(_) -> false.

is_foo_term1(A) when A == foo -> true;
is_foo_term1(_) -> false.

is_foo_term2(A) when foo == A -> true;
is_foo_term2(_) -> false.

%%---------------------------------------------------------------------
%% Same for these cases

is_nonfoo_exact(A) when A =/= foo -> true;
is_nonfoo_exact(_) -> false.

is_nonfoo_term1(A) when A /= foo -> true;
is_nonfoo_term1(_) -> false.

is_nonfoo_term2(A) when foo /= A -> true;
is_nonfoo_term2(_) -> false.

%%---------------------------------------------------------------------

is_tuple_skel({A,{B},[C]}) when is_atom(A), is_integer(B), is_atom(C) -> true;
is_tuple_skel(T) when is_tuple(T) -> false.

is_tuple_exact(T) when T =:= {a,{42},[c]} -> true;
is_tuple_exact(T) when is_tuple(T) -> false.

is_tuple_term(T) when T == {a,{42.0},[c]} -> true;
is_tuple_term(T) when is_tuple(T) -> false.

%%---------------------------------------------------------------------
%% But for binaries the treatment has to be different, due to the need
%% for construction of the binary in the guard.

is_bin_exact(B) when B =:= <<42>> -> true;
is_bin_exact(_) -> false.

is_bin_term1(B) when B == <<42>> -> true;
is_bin_term1(_) -> false.

is_bin_term2(B) when <<42>> == B -> true;
is_bin_term2(_) -> false.

%%---------------------------------------------------------------------

compile(Flags) ->
  hipe:c(?MODULE,Flags).

