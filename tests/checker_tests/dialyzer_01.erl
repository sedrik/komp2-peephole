-module(dialyzer_01).
-export([test/0]).

-define(QUICK_TEST, true).

-spec test() -> [_].

-ifdef(QUICK_TEST).
test() ->
  Files = filelib:wildcard("di*.erl"),
  dialyzer:run([{files,Files},{from,src_code}]).
-else.	%% this really takes long time
test() ->
  Ebins = filelib:wildcard(filename:join(code:lib_dir(), "typer/ebin")),
  dialyzer:run([{files,Ebins}]).
-endif.
