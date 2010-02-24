%% ====================================================================
%% Test module for the HiPE test suite.  Taken from process_SUITE.erl
%%
%%  Filename :  proc_test4.erl
%%  Purpose  :  Checks correct exit of processes.
%%  History  :  * 2001-08-13 Kostis Sagonas (kostis@csd.uu.se): Created.
%% CVS:
%%    $Author: richardc $
%%    $Date: 2004/08/20 14:35:15 $
%%    $Revision: 1.4 $
%% ====================================================================

-module(proc_test4).
-export([test/0,compile/1]).
%% the following is used in a remote call context
-export([fun_init/1]).

test() ->
    {normal_suicide_exit(foo),abnormal_suicide_exit(bar)}.
    
compile(Flags) ->
    hipe:c(?MODULE,Flags).

%% Tests exit(self(), Term) is equivalent to exit(Term) for a process
%% that doesn't trap exits.

normal_suicide_exit(suite) -> [];
normal_suicide_exit(_) ->
    process_flag(trap_exit, true),
    flush(),
    Pid = fun_spawn(fun() -> exit(self(), normal) end),
    Res = receive
	      {'EXIT', Pid, normal} -> ok;
	      Other -> exit({normal_suicide_exit,bad_message,Pid,Other})
	  end,
    process_flag(trap_exit, false),
    Res.
    

%% Tests exit(self(), Term) is equivalent to exit(Term) for a process
%% that doesn't trap exits.

abnormal_suicide_exit(suite) -> [];
abnormal_suicide_exit(_) ->
    Garbage = eight_kb(),
    process_flag(trap_exit, true),
    Pid = fun_spawn(fun() -> exit(self(), Garbage) end),
    Res = receive
	      {'EXIT', Pid, Garbage} -> ok;
	      Other -> exit({abnormal_suicide_exit,bad_message,Other})
	  end,
    process_flag(trap_exit, false),
    Res.

%% AUXILIARY FUNCTIONS USED BY THE TEST

fun_init(Fun) ->
    Fun().
fun_spawn(Fun) ->
    spawn_link(?MODULE, fun_init, [Fun]).

flush() ->
    receive _ -> flush() after 0 -> ok end.

eight_kb() ->
    B64 = lists:seq(1, 64),
    B512 = {B64, B64, B64, B64, B64, B64, B64, B64},
    lists:duplicate(8, {B512, B512}).
