-module(fun02).
-export([test/0,compile/1,f/4]).

test() ->
  t2(?MODULE,f).

compile(Flags) ->
  hipe:c(?MODULE,Flags).

t2(M,F) ->
  M:F(bar,42,foo,14).

f(_,_,foo,_) ->
  ok.
