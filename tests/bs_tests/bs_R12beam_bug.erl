%% -*- erlang-indent-level: 2 -*-

-module(bs_R12beam_bug).
-export([test/0, compile/1]).

test() ->
  run(100),
  run(100),
  run(100),
  run(100),
  ok.

%% For testing - runs scanner N number of times with same input
run(N) ->
  lists:foreach(fun(_) -> scan(<<"region:whatever">>, []) end, lists:seq(1, N)).

scan(<<>>, TokAcc) ->
  lists:reverse(['$thats_all_folks$' | TokAcc]);
scan(<<D, Z, Rest/binary>>, TokAcc) when (D =:= $D orelse D =:= $d) and
					 ((Z =:= $\s) or (Z =:= $() or (Z =:= $))) ->
  scan(<<Z, Rest/binary>>, ['AND' | TokAcc]);
scan(<<D>>, TokAcc) when (D =:= $D) or (D =:= $d) ->
  scan(<<>>, ['AND' | TokAcc]);
scan(<<N, Z, Rest/binary>>, TokAcc) when (N =:= $N orelse N =:= $n) and
					 ((Z =:= $\s) or (Z =:= $() or (Z =:= $))) ->
  scan(<<Z, Rest/binary>>, ['NOT' | TokAcc]);
scan(<<C, Rest/binary>>, TokAcc) when (C >= $A) and (C =< $Z);
                                      (C >= $a) and (C =< $z);
                                      (C >= $0) and (C =< $9) ->
  case Rest of
    <<$:, R/binary>> ->
      scan(R, [{'FIELD', C} | TokAcc]);
    _ ->
      scan(Rest, [{'KEYWORD', C} | TokAcc])
  end.

compile(Opts) ->
  hipe:c(?MODULE, Opts).
