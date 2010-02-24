%%----------------------------------------------------------------------
%% From: Sergey S, Feb 14, 2009 -- Fixed by Mikael P, Feb 20, 2009
%% 
%% While playing with parameterized modules, I found that they aren't 
%% completely supported by HiPE. It was expressed that my HiPE compiled 
%% server involving parameterized modules crashed, when I started it. 
%%----------------------------------------------------------------------

-module(param_srv).

-export([test/0, compile/1]).

-define(RCV, param_rcv).
-define(RCV_FILE, "aux_files/param_rcv.erl").

test() ->
    c:c(?RCV_FILE),		%% compile and load the receiver param module
    case whereis(?MODULE) of
	undefined ->
	    spawn(fun() -> register(?MODULE, self()), loop(fun handler/1) end),
	    timer:sleep(500);
	_ -> ok
    end,
    doit = (?MODULE ! doit),
    ok.

handler(Req) ->
    io:format("# ~p~n", [Req:get_time()]).

loop(Handler) ->
    receive
	doit ->
	    Handler(?RCV:new(time())), 
	    loop(Handler); 
	stop -> 
	    ok 
    end. 

compile(Opts) ->
    hipe:c(?MODULE, Opts).
