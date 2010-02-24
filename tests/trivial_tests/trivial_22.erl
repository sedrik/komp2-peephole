%%%-------------------------------------------------------------------
%%% File : trivial_22.erl 
%%% Author : Per Gustafsson <pergu@dhcp-12-245.it.uu.se> 
%%% Description : Tests that excessive dead code elimination, which
%%%               breaks the semantics of Erlang, is not performed.
%%%
%%% Created :  6 May 2004 by Per Gustafsson <pergu@it.uu.se>
%%%-------------------------------------------------------------------
-module(trivial_22).
-export([test/0, compile/1]).

compile(Flags) ->
  hipe:c(?MODULE,Flags).

test() ->
  case catch foo(a) of
    {'EXIT',{badarith,_Stack}} -> ok
  end.

foo(X) ->
  g(X+7),	% was X+7 but the R12 compiler issues a warning
  X.

g(_) ->
  ok.
