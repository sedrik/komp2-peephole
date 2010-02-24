%%-------------------------------------------------------------------
%% File    : load_bug4.erl
%% Author  : Kostis Sagonas <kostis@it.uu.se>
%% Description : This test case, sent to us by Zoltan Toth, shows
%%		 that the HiPE loader does not differentiate between
%%		 exported vs. local functions when it patches call
%%		 sites. Thus, it breaks the Erlang module semantics.
%% Created : 23 Jun 2004 by Kostis Sagonas <kostis@it.uu.se>
%%-------------------------------------------------------------------
-module(load_bug4).

-export([test/0, compile/1]).

-define(OtherModule, load_bug4_mod).

compile(Flags) ->
  hipe:c(?MODULE,Flags).

test() ->
  {ok,?OtherModule} = compile:file(?OtherModule),
  ResS = statically_known_call(),
  ResD = apply_call(?OtherModule),
  {ok,ok} = {ResS,ResD},
  ok.

statically_known_call() ->
  case catch ?OtherModule:not_exported(42) of
    {'EXIT',{undef,[{?OtherModule,not_exported,_}|_]}} -> ok;
    42 -> {error,calling_unexported_function_succeeded}
  end.

apply_call(Mod) ->
  case catch Mod:not_exported(42) of
    {'EXIT',{undef,[{Mod,not_exported,_}|_]}} -> ok;
    42 -> {error,calling_unexported_function_succeeded}
  end.

