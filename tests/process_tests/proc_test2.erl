%%
%% This module is troublesome when given a large standard heap.
%% Try: test.script -e "-h 500000" -t proc_test2

-module(proc_test2).

-export([start/0,bench/3, cell/0]). 
-export([test/0,compile/1]).

test() ->
  start().

compile(Flags) ->
  hipe:c(?MODULE,Flags).

start() ->
  statistics(runtime),
  R = bench(10,10,1000),
  {_,Time} = statistics(runtime),
  io:format("\nruntime = ~p msecs\nresult = ~p\n",[Time,R]),
  R.

%%
%% start 
%%

bench(N,M,Num) ->
%  io:format("~w\n",[?LINE]),
    Raw = make(N,M),
    start_all(Raw,Num),
    sum_all(Raw).

%%
%% make matrix
%%

make(N,M) ->
%  io:format("~w\n",[?LINE]),
    Raw = make_lines(N,M,[]),
    Matrix = complete(Raw),
    link_matrix(Matrix),
    Raw.

%%
%% make random initial configuration
%%

make_lines(0,_M,L) ->
%  io:format("~w\n",[?LINE]),
    L;
make_lines(N,M,L) ->
    make_lines(N-1,M,[make_col(M) | L]).

make_col(0) ->
%  io:format("~w\n",[?LINE]),
    [];
make_col(M) ->
    [spawn(?MODULE, cell, []) | make_col(M-1)].

%%
%% link neighbours
%%

link_matrix([_,_]) ->
%  io:format("~w\n",[?LINE]),
    ok;
link_matrix([North | Rest]) ->
    [This, South | _] = Rest,
    link_line(North, This, South),
    link_matrix(Rest).

link_line([_,_], _, _) ->
%  io:format("~w\n",[?LINE]),
    ok;
link_line([NW | RestN], [W | RestW], [SW | RestS]) ->
    [N, NE | _] = RestN,
    [This, E | _] = RestW,
    [S, SE | _ ] = RestS,
    This ! {neighbours, [NW,N,NE,W,E,SW,S,SE]},
    link_line(RestN, RestW, RestS).

%%
%% start reproduction of all cells
%%

start_all([], _) ->
%  io:format("~w\n",[?LINE]),
    true;
start_all([L|Ls], N) ->
    start_line(L, N),
    start_all(Ls, N).

start_line([], _) ->
%  io:format("~w\n",[?LINE]),
    true;
start_line([X|Xs], N) ->
    X ! {go, self(), 1, N},
    start_line(Xs, N).

sum_all([]) ->
%  io:format("~w\n",[?LINE]),
    0;
sum_all([L|Ls]) ->
    sum_line(L) + sum_all(Ls).

sum_line([]) ->
    0;
sum_line([X|Xs]) ->
%  io:format("~w\n",[?LINE]),
    receive
	{X, Last} ->
	    continue
    end,
    Last + sum_line(Xs).

%%
%% cell behaviour
%%

cell() ->
%  io:format("~w\n",[?LINE]),
    receive
	{neighbours, Xs} ->
	    continue
    end,
    receive
	{go, Pid, N, Num} ->
	    continue
    end,
    cell_iter(Xs, N, Num, Pid).


cell_iter(_, N, 0, Pid) ->
%  io:format("~w\n",[?LINE]),
    Pid ! {self(), N};
cell_iter(Xs, N, Num, Pid) ->
%  io:format("~w\n",[?LINE]),
    send_nghs(Xs, N),
    cell_iter(Xs, repro(N, receive_nghs(Xs, 0)), Num-1, Pid).

send_nghs([], _) ->
%  io:format("~w\n",[?LINE]),
    true;
send_nghs([X|Xs], N) ->
%  io:format("~w\n",[?LINE]),
    X ! {self(), state, N},
    send_nghs(Xs, N). 

receive_nghs([], N) -> 
%  io:format("~w\n",[?LINE]),
    N;
receive_nghs([X|Xs], N) ->
%  io:format("~w\n",[?LINE]),
    receive
	{X, state, M} ->
	    receive_nghs(Xs, N+M)
    end.

%%
%% cell reproduction
%%

repro(N, S) ->
%  io:format("~w\n",[?LINE]),
    if 
	S <2 -> 0;
        S==2 -> N;
	S==3 -> 1;
	S >3 -> 0
    end.

%%
%% complete torus
%%

complete(Ls) ->
%  io:format("~w\n",[?LINE]),
    complete_list(complete_lines(Ls)). 

complete_lines([]) ->
%  io:format("~w\n",[?LINE]),
    [];
complete_lines([L|Ls]) ->
    [complete_list(L) | complete_lines(Ls)].

complete_list(Ls) ->
    [last(Ls) | append(Ls, [nth(1,Ls)] )].

last([L]) ->
%  io:format("~w\n",[?LINE]),
  L;
last([_|M]) -> last(M).

append(L1,L2) ->
%%   io:format("~w\n",[?LINE]),
    L1 ++ L2.

nth(1,[E|_]) -> 
%  io:format("~w\n",[?LINE]),
    E;
nth(N,[_|L]) -> 
    nth(N-1,L).

