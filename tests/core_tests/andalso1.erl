-module(andalso1).
-export([test/0, compile/1]).

test() ->
  t(true, false).

t(A, B) ->
  if A andalso B -> error;
     true -> ok
  end.

compile(Opts) ->
  hipe:c(?MODULE, [core,{pmatch, no_duplicates}|Opts]).

