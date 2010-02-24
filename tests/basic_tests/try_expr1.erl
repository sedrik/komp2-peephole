%% -*- erlang-indent-level: 2 -*-
%% ====================================================================
%%  Filename :  try_expr1.erl
%%  Purpose  :  Checks correct handling of try expressions.
%%  History  :  2003-02-28 Kostis Sagonas (kostis@csd.uu.se): Created.
%% CVS:
%%    $Author: kostis $
%%    $Date: 2006/07/21 14:14:38 $
%%    $Revision: 1.3 $
%% ====================================================================

-module(try_expr1).
-export([test/0, compile/1]).

test() ->
  %% Uncomment the following line to see that there can be mucho
  %% confusion in the handling of 'undefined function' exceptions
  %%
  %% erlang:element(3,erlang:now()),
  try 'non existing module':t() of
    a -> ok
  catch
    error:_Reason ->
      exception_caught_properly;
    Class:Reason ->
      {caught_a_weird_exception,{Class,Reason}}
  end.

compile(Flags) ->
  hipe:c(?MODULE,Flags).
