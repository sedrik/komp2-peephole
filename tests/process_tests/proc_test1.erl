%% Copyright (c) 1999 by Erik Johansson.  All Rights Reserved 
%% ====================================================================
%% Test module for the HiPE test suite.
%%
%%  Filename : 	testN.erl
%%  Module   :	testN
%%  Purpose  :  
%%  Notes    :  Adapted from after_SUITE by 'bjorn@erix.ericsson.se'.
%%  History  :	* 1999-12-05 Erik Johansson (happi@csd.uu.se): Created.
%% CVS:
%%    $Author: richardc $
%%    $Date: 2004/08/20 14:11:02 $
%%    $Revision: 1.8 $
%% ====================================================================
%% Exported functions (short description):
%%  test()         - execute the test.
%%  compile(Flags) - Compile to native code with compiler flags Flags.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-module(proc_test1).
-export([test/0,compile/1]).

%% Internal exports.
-export([fun_init/1]).


test() ->
  R1 = t_after(),
  R2 = receive_after(),
  {R1,R2}.

compile(Flags) ->
  hipe:c(?MODULE,Flags).

%% t_after:
%% Make sure that timeouts are accurate 'enough'. 
%%
t_after() ->
     fun_spawn(fun frequent_process/0),
     Period = minutes(0.25),
     Before = erlang:now(),
    receive
	after Period ->
		 After = erlang:now(),
		 report(Period, Before, After)
	end.


report(Period, Before, After) ->
     Elapsed = (element(1, After)*1000000000
		     +element(2, After)*1000
		     +element(3, After) div 1000) -
	(element(1,Before)*1000000000
	 + element(2,Before)*1000 + element(3,Before) div 1000),
     case Elapsed*100 / Period of
	      Percent when Percent > 105.0 ->
		   {too_late, Percent};
	      Percent when Percent < 100.0 ->
		   {too_early, Percent};
	      _ ->
	           'Elapsed/expected'
	  end.

frequent_process() ->
    receive
	after 10000 ->
		 frequent_process()
	end.

%% Test that 'receive after' works (doesn't hang).
%% The test takes 10 seconds to complete.

receive_after() ->
     receive_after1(5000).

receive_after1(1) ->
     receive after 1 -> ok end;
receive_after1(N) -> 
     receive after N -> receive_after1(N div 2) end.



%%% Utilities.

fun_spawn(Fun) ->
    spawn_link(?MODULE, fun_init, [Fun]).

fun_init(Fun) ->
    Fun().

minutes(N) -> trunc(N * 1000 * 60).
