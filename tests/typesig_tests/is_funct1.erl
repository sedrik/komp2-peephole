%%-------------------------------------------------------------------
%% File    : is_funct1.erl
%% Author  : Kostis Sagonas <kostis@it.uu.se>
%% Description : Tests the handling of the new is_function/2 type guard.
%%
%% Created : 5 Jul 2005 by Kostis Sagonas <kostis@it.uu.se>
%%-------------------------------------------------------------------

-module(is_funct1).
-export([f/1, f1/2, f2/2, f3/1]).

f(F) when is_function(F,1) ->
  ok.

f1(F,N) when is_function(F,N) ->
  case N of
    1 -> unary;
    2 -> binary
  end.

f2(F,N) when is_function(F,N) ->
  case N of
    2 -> binary
  end.

f3(F) when is_function(F,3) ->
  F.
