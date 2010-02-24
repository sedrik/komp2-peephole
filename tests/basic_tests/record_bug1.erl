-module(record_bug1).
-export([test/0, compile/1]).

-record(r, {ra}).
-record(s, {sa,sb,sc,sd}).

test() ->
    R = #r{},
    S = #s{},
    S1 = S#s{sc=R, sd=1},
    R1 = S1#s.sc,
    undefined = R1#r.ra,
    ok.

compile(Opts) ->
    hipe:c(?MODULE, Opts).
