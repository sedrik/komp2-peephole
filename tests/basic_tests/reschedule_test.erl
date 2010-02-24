%%% $Id: reschedule_test.erl,v 1.2 2007/11/25 18:15:32 mikpe Exp $
%%% Check that RESCHEDULE returns from BIFs work.

-module(reschedule_test).
-export([test/0, compile/1]).

compile(Flags) ->
    hipe:c(?MODULE, Flags).

test() ->
    erts_debug:set_internal_state(available_internal_state, true),
    First = self(),
    Second = spawn(fun() -> doit(First) end),
    receive
	Second ->
	    []
    end,
    receive
    after 1000 ->
	    []
    end,
    erts_debug:set_internal_state(hipe_test_reschedule_resume, Second),
    ok.

doit(First) ->
    First ! self(),
    erts_debug:set_internal_state(hipe_test_reschedule_suspend, 1).
