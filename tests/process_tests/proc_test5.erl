%% ====================================================================
%% Test module for the HiPE test suite.  Taken from process_SUITE.erl.
%%
%%  Filename :  proc_test5.erl
%%  Purpose  :  Tests the process info BIF.
%%  History  :  * 2001-09-19 Kostis Sagonas (kostis@csd.uu.se): Created.
%% CVS:
%%    $Author: kostis $
%%    $Date: 2002/05/07 13:06:34 $
%%    $Revision: 1.3 $
%% ====================================================================

-module(proc_test5).
-export([test/0,compile/1]).

test() ->
    t_process_info().
    
compile(Flags) ->
    hipe:c(?MODULE,Flags).

%%
%% The case statement is used so as to make the code re-entrant.
%%
t_process_info() ->
    case process_info(self(), registered_name) of
	[] ->
	    register(my_name, self());
	{registered_name,my_name} ->
	    ok;
        Other ->
	    exit(Other)
    end,
    {registered_name, my_name} = process_info(self(), registered_name),
    {status, running} = process_info(self(), status),
    %% {current_function, {?MODULE,t_process_info,0}} =
    %%     process_info(self(), current_function),
    Gleader = group_leader(),
    {group_leader, Gleader} = process_info(self(), group_leader),
    {'EXIT',{badarg,_Info}} = (catch process_info('not_a_pid')),
    ok.

