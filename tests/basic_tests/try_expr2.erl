%% -*- erlang-indent-level: 2 -*-
%% ====================================================================
%%  Filename : try_expr2.erl
%%  Purpose  : Checks correct handling of try expressions.
%%  Creator  : Erik Stenman <Erik.Stenman@epfl.ch>
%% CVS:
%%    $Author: kostis $
%%    $Date: 2006/07/21 11:59:51 $
%%    $Revision: 1.2 $
%% ====================================================================

-module(try_expr2).
-export([test/0, compile/1]).

test() ->
  {[c(foo),
    c('exit'),
    c('fault'),
    c(other),
    c('throw')],
   [t(foo),
    t('exit'),
    t('fault'),
    t(other),
    t('throw')]}.

t(V) ->
  try seq(V) of
    foo -> bar;
    Other -> Other
  catch
    exit:{What,TraceList} -> [Head|_] = TraceList, {What,[Head]};
    exit:Reason when is_atom(Reason) -> Reason;
    error:OtherException -> {OtherException, case erlang:get_stacktrace() of
					       [] -> [];
					       S when is_list(S) -> [hd(S)]
					     end};
    throw:OtherException -> OtherException
  end.

c(V) ->
  case catch seq(V) of
    foo -> bar;
    {'EXIT',{What,TraceList}} ->
      case TraceList of
	[] -> {What,[]};
	[Head|_] -> {What,[Head]}
      end;
    {'EXIT',Reason} when is_atom(Reason) -> Reason;
    OtherException -> OtherException
  end.

seq(foo) ->
  foo;
seq(exit) ->
  exit(foo);
seq(throw) ->
  throw('throwing');
seq(Y=fault) ->
  x = Y;
seq(_) ->
  other.

compile(Flags) ->
  hipe:c(?MODULE, Flags).
