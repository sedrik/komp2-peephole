%%%---------------------------------------------------------------------------------
%%% File        : hipe_zombie_test.erl
%%% Author      : Per Gustafsson <pergu@it.uu.se>
%%% Description : Checks that HiPE's concurrent compilation does not leave any
%%%		  zombie processes after compilation has finished.
%%%		  This is a bug reported on erlang-bugs
%%% Created     : 25 Oct 2007 by Per Gustafsson <pergu@it.uu.se>
%%%---------------------------------------------------------------------------------
-module(hipe_zombie_test).

-export([test/0,compile/1]).

compile(Opts) ->
  hipe:c(?MODULE, Opts).

test() ->
  L = length(processes()),
  hipe:c(?MODULE, [concurrent_comp]),	% force concurrent compilation
  L = length(processes()),
  ok.
