%% ====================================================================
%%  Filename :  try_expr3.erl
%%  Purpose  :  Checks correct handling of try expressions that throw
%%              exceptions themselves.  According to the Erlang manual: 
%%                "If an exception occurs during evaluation of Expr 
%%                 but there is no matching ExceptionPattern of the
%%                 right Class with a true guard sequence, the exception
%%                 is passed on as if Expr had not been enclosed in a
%%                 try expression."
%%  History  :  2006-07-21 Kostis Sagonas (kostis@csd.uu.se): Created.
%% CVS:
%%    $Author: kostis $
%%    $Date: 2006/07/21 13:17:11 $
%%    $Revision: 1.1 $
%% ====================================================================

-module(try_expr3).
-export([test/0, compile/1]).

test() ->
  catch exception().

exception() ->
  try
    throw('i.wonder.who.will.catch.me')
  catch
    error:Error ->
      io:format("function f caused an error: ~p~n", [Error])
  end.

compile(Flags) ->
  hipe:c(?MODULE,Flags).
