%%-------------------------------------------------------------------
%% File    : list2.erl
%% Author  : Kostis Sagonas <kostis@it.uu.se>
%% Description : Test that list types have some decent representation
%%		 that allows inference of type discrepancies.
%%
%%% Created :  1 Feb 2004 by Kostis Sagonas <kostis@it.uu.se>
%%-------------------------------------------------------------------

-module(list2).
-export([test/0]).

test()->
  {l_one(), l_atom()}.

l_one() ->
  l_one([1,2]).	%% this call does not succeed

l_one([1]) -> ok.

l_atom() ->
  l_atom([1]).	%% this call cannot succeed

l_atom([A]) when is_atom(A) -> ok.
