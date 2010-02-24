%% -*- erlang-indent-level: 2 -*-
%% ====================================================================
%% Test module for the HiPE test suite.  Taken from fun_SUITE.erl
%%
%%  Filename :  exception02.erl
%%  Purpose  :  Checks correct exception throwing when calling a bad fun.
%%  History  :  * 2001-09-20 Kostis Sagonas (kostis@csd.uu.se): Created.
%% CVS:
%%    $Author: kostis $
%%    $Date: 2004/02/06 20:11:33 $
%%    $Revision: 1.4 $
%% ====================================================================

-module(exception02).
-export([test/0,compile/1,bad_fun_call/0]).

test() ->
  bad_fun_call().

compile(Flags) ->
  hipe:c(?MODULE,Flags).

bad_fun_call() ->
  bad_call_fc(42),
  bad_call_fc(xx),
  bad_call_fc({}),
  bad_call_fc({1}),
  bad_call_fc({1,2,3}),
  bad_call_fc({1,2,3}),
  bad_call_fc({1,2,3,4}),
  bad_call_fc({1,2,3,4,5,6}),
  bad_call_fc({1,2,3,4,5}),
  bad_call_fc({1,2}),
  ok.

bad_call_fc(Fun) ->
  Args = [some,stupid,args],
  Res = (catch Fun(Fun(Args))),
  case Res of
    {'EXIT',{{badfun,Fun},_Where}} ->
      ok; %% = io:format("~p(~p) -> ~p\n", [Fun,Args,Res]);
    Other ->
      io:format("~p(~p) -> ~p\n", [Fun,Args,Res]),
      exit({bad_result,Other})
  end.
