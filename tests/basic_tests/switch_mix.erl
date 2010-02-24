-module(switch_mix).
-export([test/0,compile/1]).

test() ->
  {t(42),t(17),t(2132323322),t(42424242424242), t(foo), t(self()),t(4.2)}.

t(V) ->
  S = self(),
  case V of
    42 ->
      small1;
    17 ->
      small2;
    2132323322 ->
      big1;
    42424242424242 ->
      big2;
    1 -> no;
    2 -> no;
    3 -> no;
    4 -> no;
    5 -> no;
    6 -> no;
    7 -> no;
    8 -> no;
    foo -> ok;
    4.2 -> float;
    S -> pid;
    _ -> true
  end.

compile(Flags) ->
  hipe:c(?MODULE,Flags).
