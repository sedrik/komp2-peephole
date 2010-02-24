%%%-------------------------------------------------------------------
%%% File    : bs17.erl
%%% Author  : Per Gustafsson <pergu@it.uu.se>
%%% Description : 
%%%           Crashed on sparc due to abug in linear scan
%%% Created :  9 May 2005 by Per Gustafsson <pergu@it.uu.se>
%%%-------------------------------------------------------------------
-module(bs17).
-export([test/0,compile/1]).

compile(O) ->
  hipe:c(?MODULE,O).

test() ->
  a(<<1,2,3,4,5,6,7,8>>).

a(<<A,B,C,D,A1,B1,C1,D1>>) ->
  foo(A,B,C,D),
  foo(A1,B1,C1,D1).

foo(X,Y,Z,W) ->
  X+Y+Z+W.
