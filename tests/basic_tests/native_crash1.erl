%%-----------------------------------------------------------------------
%% From: Sergey S, mid January 2009.
%%
%%   While I was playing with +native option, I run into a bug in HiPE
%%   which leads to segmentation fault using +native and Erlang R12B-5.
%% 
%%   Eshell V5.6.5  (abort with ^G)
%%   1> crash:test().
%%   # Some message to be printed here each loop iteration
%%   Segmentation fault
%%
%% Diagnozed and fixed by Mikael Petterson (22 Jan 2009):
%%
%%   I've analysed the recently posted HiPE bug report on erlang-bugs
%%   <http://www.erlang.org/pipermail/erlang-bugs/2009-January/001162.html>.
%%   The segfault is caused by memory corruption, which in turn is caused
%%   by RTL removing an update of the HP (heap pointer) register due to
%%   what looks like broken liveness information.
%%-----------------------------------------------------------------------

-module(native_crash1).

-export([test/0, compile/1]).

test() ->
    spawn(fun() -> init() end),
    ok.

init() ->
    repeat(5, fun() -> void end),
    receive after infinity -> ok end.

repeat(0, _) ->
    ok;
repeat(N, Fun) ->
    io:format("# Some message to be printed here each loop iteration\n"),
    Fun(),
    repeat(N - 1, Fun).

compile(Opts) ->
    hipe:c(?MODULE, Opts).
