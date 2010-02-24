-module(hinde_R10compiler_bug).
-export([test/0, compile/1]).

-record(r, {a,b,c}).

test() ->
  test(#r{}).

test(As) ->
  case As of
    A when A#r.b == ""; A#r.b == undefined ->
      ok;
    _ ->
      weird
  end.

compile(Opts) ->
  hipe:c(?MODULE, Opts).
