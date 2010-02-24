%% Module which shows how the constraints generated for ==/2 are losing
%% information that N in the first clause is an atom (which is what the
%% call to erlang:node/0 will return).

-module(spawn4).
-export([spawn/4]).

spawn(N,M,F,A) when N == node(), is_atom(M), is_atom(F), is_list(A) ->
    spawn(M,F,A);
spawn(N,M,F,A) when is_atom(N), is_atom(M), is_atom(F), length(A) >= 0 ->
    case catch gen_server:call({net_kernel,N},
			       {spawn,M,F,A,group_leader()},
			       infinity) of
	Pid when is_pid(Pid) ->
	    Pid;
	Error ->
	    case erlang:remote_spawn_error(Error, {no_link, N, M, F, A, []}) of
		{fault, Fault} ->
		    erlang:error(Fault, [N, M, F, A]);
		Pid when is_pid(Pid) ->
		    Pid
	    end
    end.

