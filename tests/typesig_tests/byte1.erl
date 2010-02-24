%%-------------------------------------------------------------------
%% File    : byte1.erl
%% Author  : Kostis Sagonas <kostis@it.uu.se>
%% Description : Tests inferrence of integer ranges which are bytes.
%%
%% Created : 7 Jan 2007 by Kostis Sagonas <kostis@it.uu.se>
%%-------------------------------------------------------------------
-module(byte1).
-export([is_byte/1]).

is_byte(X) when is_integer(X), 0 =< X, X =< 255 -> true.

