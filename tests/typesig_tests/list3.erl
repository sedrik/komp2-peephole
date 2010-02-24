%%-------------------------------------------------------------------
%% File    : list3.erl
%% Author  : Kostis Sagonas <kostis@it.uu.se>
%% Description : Tests backwards and module-local propagation of lists
%%		 (code taken from hipe_beam_to_icode.erl).
%%
%% Created : 16 Mar 2005 by Kostis Sagonas <kostis@it.uu.se>
%%-------------------------------------------------------------------

-module(list3).
-export([mystery/1]).

mystery([]) ->
  [];
mystery([H|T]) ->
  mystery(H, T).

mystery(I, Acc) when is_integer(I)  ->
  lists:reverse([I | Acc]).
