%%%-------------------------------------------------------------------
%%% File    : constant_binary.erl
%%% Author  : Per Gustafsson <pergu@fan.it.uu.se>
%%% Description : Creates one constant binary and one 
%%%               non-constant binary
%%%
%%% Created : 11 Jun 2007 by Per Gustafsson <pergu@fan.it.uu.se>
%%%-------------------------------------------------------------------
-module(constant_binary).

-export([test/0, compile/1]).

compile(Opts) ->
  hipe:c(?MODULE, [core|Opts]).

test() ->
  <<1>> = a(1),
  <<1>> = b(),
  
  ok.

a(X) ->
  <<X>>.

b() ->
  <<1>>.
