-module(guard02).
-export([test/0, compile/1]).

test() ->
   {ok1, not_a_bool_guard, ok2} = {test(true), test(42), test(false)},
   ok.

test(X) when X ->  % gets transformed to:  is_boolean(X), X =:= true
  ok1;
test(X) when X =:= false ->
  ok2;
test(_) ->
  not_a_bool_guard.

compile(Opts) ->
  hipe:c(?MODULE, Opts).
