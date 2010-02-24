%%-------------------------------------------------------------------
%% File    : fun4.erl
%% Author  : Kostis Sagonas <kostis@it.uu.se>
%% Description : Tests combination of atoms, function arguments, and
%%		 the influence of functions that do not return values
%%		 other than via message passing (idea inspired from
%%		 runtime_tools/src/dbg.erl).
%%
%% Created : 17 Mar 2005 by Kostis Sagonas <kostis@it.uu.se>
%%-------------------------------------------------------------------

-module(fun4).
-export([start/0]).

start() ->
    start(no_tracer).

start(TracerFun) ->
    S = self(),
    case whereis(?MODULE) of
	undefined ->
	    P = spawn(fun() -> init(S) end),
	    receive {P,started} -> ok end,
	    case TracerFun of
		no_tracer ->
		    {ok, P};
		Fun when is_function(Fun) ->
		    {tracer,TracerFun}
	    end;
	Pid when is_pid(Pid), is_function(TracerFun) ->
	    {tracer,TracerFun}
    end.

init(Parent) ->
    process_flag(trap_exit, true),
    register(?MODULE, self()),
    Parent ! {self(),started},
    Reply = other_mod:get_reply(),
    loop(Reply).

loop(R) ->
    receive 
        {From,heaven} ->
	    reply(From, angelic:call(R)),
	    loop(R);
       %% {From,outer_space} ->
       %%     extraterrestrial:call(R);
	{From,hell} ->
	    reply(From, 'fan!'),
	    exit(done);
	Other ->
	    loop(Other)
    end.

reply(Pid, Reply) ->
    Pid ! {?MODULE,Reply}.
