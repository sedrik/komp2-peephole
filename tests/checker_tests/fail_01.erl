%% -*- erlang-indent-level: 2 -*-

%% @author Daniel Luna <luna@update.uu.se>
%% @copyright 2008 Daniel Luna
%% 
%% @doc 
%% 

-module(fail_01).
-export([test/0]).

-spec(test/0 :: () -> 'ok').
test() ->
  %% io:format(atom_to_list(?MODULE) ++ " running~n"),
  two(3),
  takes_atom(5),
  test_contract_print_order(ok, 1, ok),
  ko.

-spec(two/1 :: (2 | 1) -> 5).
two(_X) ->
  5.

-spec(takes_atom/1 :: (atom()) -> atom()).
takes_atom(Atom) ->
  Atom.

-spec(test_contract_print_order/3 :: (atom(), integer(), tuple()) -> atom()).
test_contract_print_order(_, _, _) -> ok.
