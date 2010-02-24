%% -*- erlang-indent-level: 2 -*-
%%====================================================================
%% Sending 'test' to this process should return 'ok'.  But:
%% 
%% 1> x:test().
%% Weird: received true
%% timeout
%% 
%% NOTE that the message has been bound to the value of 'ena' in
%% the record!  If you look at the .S file, you'll see the problem...
%%====================================================================

-module(record_bug2).
-export([test/0, compile/1, loop/1]).

-record(state, {ena = true}).

test() ->
  P = spawn_link(?MODULE, loop, [#state{}]),
  P ! {msg,self()},
  receive
    What -> What
  after 20 -> timeout
  end.

loop(S) ->
  receive
    _ when S#state.ena == false ->
        io:format("Weird: ena is false\n");
        % loop(S);
    {msg,Pid} ->
        Pid ! ok;
        % loop(S);
    Other ->
        io:format("Weird: received ~p\n", [Other])
        % loop(S)
  end.

compile(Opts) ->
  hipe:c(?MODULE, Opts).
