%%-------------------------------------------------------------------
%% File    : list5.erl
%% Author  : Kostis Sagonas <kostis@it.uu.se>
%% Description : Stresses limits of inferring that lists are proper.
%%		 Without sophisticated analysis both functions are
%%		 found to be taking possibly improper lists as
%%		 arguments. Finding that *both* functions can only
%%               accept proper lists in this example might need
%%               dependent types.
%%
%% Created : 17 Mar 2005 by Kostis Sagonas <kostis@it.uu.se>
%%-------------------------------------------------------------------

-module(list5).
-export([exported/1]).

exported([I|Rest]) ->
  case is_even(I) of
    false ->
      exported(internal(Rest));
    true ->
      [I|exported(Rest)]
  end;
exported([]) ->
  [].

internal([I|Rest]) ->
  case is_even(I) of
    false -> [I|Rest];
    true -> internal(Rest)
  end;
internal([]) ->
  [].

is_even(I) ->
  I rem 2 == 0.
