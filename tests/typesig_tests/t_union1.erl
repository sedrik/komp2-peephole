%%-------------------------------------------------------------------
%% File    : t_union1.erl
%% Author  : Kostis Sagonas <kostis@it.uu.se>
%% Description : Tests correct solving of constraints involving unions.
%%
%% Created : 2 Feb 2005 by Kostis Sagonas <kostis@it.uu.se>
%%-------------------------------------------------------------------
-module(t_union1).
-export([mystery1/1, mystery2/1]).

a_or_b(X) when is_atom(X) -> a;
a_or_b(X) when is_binary(X) -> b.

mystery1(X) ->
  R = a_or_b(X),
  a = R,	%% constrain the type of R
  R.

mystery2(X) ->
  true = is_binary(atom_or_binary(X)).

atom_or_binary(X) when is_atom(X) -> an_atom;
atom_or_binary(X) when is_binary(X) -> <<>>.
