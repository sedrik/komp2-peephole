%% From Simon Cornish Jan 13, 2008; 10:20am
%% The attached Erlang code demonstrates an R12B-0 bug with funs.
%% Compile and evaluate the two die/1 calls for two different failure modes.
%% It seems to me that the live register check for call_fun is off by one. 

-module(broken_fun).
-export([test/0, compile/1]).

-record(b, {c}).

test() ->
  {a2, a} = die(a),
  {a2, {b,c}} = die({b,c}),
  ok.

die(A) ->
  F = fun() -> {ok, A} end,
  if A#b.c =:= [] ->
      one;
    true ->
      case F() of
	{ok, A2} ->
	  {a2, A2};
	_ ->
	  three
      end
  end.

compile(Opts) ->
  hipe:c(?MODULE, Opts).
