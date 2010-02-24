%% -*- erlang-indent-level: 2 -*-

%% @author Daniel Luna <luna@update.uu.se>
%% @copyright 2008 Daniel Luna
%% 
%% @doc 
%% 

-module(pp_01).
-export([test/0]).

-spec(test/0 :: () -> 'ok').
test() ->
  test_contract_print_order(one, two, three),
  more_pp_testing(first, second, third),
  even_more_pp_testing(),
  ok.

-spec(test_contract_print_order/3 :: ('first', 'second', 'third') -> atom()).
test_contract_print_order(_, _, _) -> ok.

-spec(more_pp_testing/3 :: ('one', 'two', 'three') -> atom();
      (1, 2, 3) -> integer()).
more_pp_testing(_,_,_) -> ok.
  
-spec(even_more_pp_testing/0 :: () -> 'first';
      () -> 'second').
even_more_pp_testing() -> ok.
