%% File which causes compilation from Core to throw an exception.
%% This is problematic for Dialyzer and it needs to be fixed.

-module(boolean1).
-export([test/0, compile/1]).

%---------------------------------------------------------------------------

-record(ticket, {passive_flag, active_flag}).

%---------------------------------------------------------------------------

test() ->
    Ticket = #ticket{passive_flag=true, active_flag=true},
    match(Ticket, Ticket).

match(#ticket{passive_flag = PP, active_flag = PA},
      #ticket{passive_flag = TP, active_flag = TA}) ->
    if
	(not(TP) orelse PP) andalso (not(TA) orelse PA) ->
	    ok;
	true ->
	    no_ok
    end.

compile(Opts) ->
  hipe:c(?MODULE, [core|Opts]).

%---------------------------------------------------------------------------
