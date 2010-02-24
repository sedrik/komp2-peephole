%% -*- erlang-indent-level: 2 -*-
-module(hipe_02).
-export([test/0]).

-spec(test/0 :: () -> {'ok',atom()}).
test() ->
  hipe:c(dialyzer_typesig, []). %o3,{regalloc,optimistic}]).
