-module(higher_order01).
-export([test/0]).

-spec(test/0 :: () -> 'ok').
test() ->
   F = mk_fun(),
   F().

-spec(mk_fun/0 :: () -> fun(() -> 'ok')).
mk_fun() ->
   fun() -> gazonk end.
