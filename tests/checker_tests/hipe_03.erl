%% -*- erlang-indent-level: 2 -*-
-module(hipe_03).
-export([test/0]).

-spec(test/0 :: () -> {'ok',atom()}).
test() ->
  hipe:c(typer, [{regalloc,optimistic},no_icode_ssa_struct_reuse]).
