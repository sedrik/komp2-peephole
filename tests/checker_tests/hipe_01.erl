%% -*- erlang-indent-level: 2 -*-
-module(hipe_01).
-export([test/0]).

-spec(test/0 :: () -> {'ok',atom()}).
test() ->
  hipe:c(?MODULE, [o3]).
