-module(put_literal).
-export([test/0, compile/1]).

test() ->
  {a,b,c,42} = mk_literal_quadruple(),
  [42,[42]] = mk_literal_deeplist(),
  ok.

mk_literal_quadruple() ->
  {a,b,c,42}.

mk_literal_deeplist() ->
  [42,[42]].

compile(Opts) ->
  hipe:c(?MODULE, Opts).
