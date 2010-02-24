-module(ring3).

-export([test/0, compile/1]).

compile(Opts) ->
    hipe:c(?MODULE, Opts).

test() ->
    ramp("ring3.txt", 1000, 0, 10000, 1000),
    ok.

ramp(File, N, From, To, Step) ->
    process_flag(trap_exit, true),
    {ok, Fd} = file:open(File, [write]),
    io:fwrite(Fd, "  N\t  Spawn\t  Send~n", []),
    lists:foreach(fun(Size) ->
			  format(Fd, do_run(N, Size))
		  end, lists:seq(From,To,Step)),
    file:close(Fd).

do_run(N, Size) ->
    Msg = payload(Size),
    Pid = spawn_link(fun() ->
			     run(N, Msg)
		     end),
    receive
	{'EXIT', Pid, Result} ->
	    {N, Result}
    end.

format(Fd, {N, {Spawn, Send}}) ->
    io:fwrite(Fd, "~w\t~w\t~w~n", [N, Spawn, Send]).
    

run(N, Msg) when is_integer(N), N > 1 ->
    {First, Last, SpawnTime} = spawn_ring(N),
    SendTime = send_ring(First, Last, Msg),
    exit({SpawnTime/N, SendTime/N}).


spawn_ring(N) ->
    Start = erlang:now(),
    StarterProcess = self(),
    First = spawn_child(N, StarterProcess),
    receive
	{Last, done} ->
	    SpawnStop = erlang:now(),
	    {First, Last, time_diff(SpawnStop, Start)}
    after 5*60000 ->
	    exit(timeout)
    end.

send_ring(First, Last, Msg) ->
    Start = erlang:now(),
    First ! {self(), {ping, Msg}},
    receive
	{Last, {ping,_}} ->
	    Stop = erlang:now(),
	    time_diff(Stop, Start)
    after 5*60000 ->
	    exit(timeout)
    end.

spawn_child(N, StarterProcess) ->
    Parent = self(),
    spawn_link(fun() ->
		       child_init(N, Parent, StarterProcess)
	       end).

child_init(1, Parent, StarterProcess) ->
    StarterProcess ! {self(), done},
    receive_loop(Parent, StarterProcess);
child_init(N, Parent, StarterProcess) ->
    Next = spawn_child(N-1, StarterProcess),
    receive_loop(Parent, Next).

receive_loop(Parent, Next) ->
    receive
	{Parent, {ping,_}=Msg} ->
	    Next ! {self(), Msg},
	    receive_loop(Parent, Next)
    end.


time_diff(After, Before) ->
    %% snipped from timer:tc/3
    _Elapsed = (element(1,After)*1000000000000 +
                element(2,After)*1000000 + 
                element(3,After)) -
        (element(1,Before)*1000000000000 +
         element(2,Before)*1000000 + element(3,Before)).

payload(Size) ->
    lists:duplicate(Size div 8, 17).

