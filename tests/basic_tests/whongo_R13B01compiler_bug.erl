-module(whongo_R13B01compiler_bug). 
-export([test/0, compile/1]). 

test() ->
  S = "gazonk",
  S = orgno_alphanum(S),
  ok.

orgno_alphanum(Cs) -> 
  [C || C <- Cs, ((C >= $0) andalso (C =< $9)) 
          orelse ((C >= $a) andalso (C =< $z)) 
          orelse ((C >= $A) andalso (C =< $Z))]. 

compile(Opts) ->
  hipe:c(?MODULE, Opts).
