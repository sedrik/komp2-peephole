%%%-------------------------------------------------------------------
%%% File    : orelse2.erl
%%% Author  : Tobias Lindahl <tobiasl@csd.uu.se>
%%% Description : This expands into a really nasty guard expression that the 
%%%               analysis chokes on. It also shows a problem in the 
%%%               compilation of orelse guards and records. 
%%%               This is a BEAM problem, and will hopefully be fixed 
%%%               by the OTP guys.
%%%
%%% Created :  6 Oct 2006 by Tobias Lindahl <tobiasl@csd.uu.se>
%%%-------------------------------------------------------------------

-module(orelse2).

-export([t1/1, t2/1, t3/1, t4/1]).

-record(foo, {baz}).
-record(bar, {baz}).

t1(X) when X#foo.baz orelse X#bar.baz ->
  ok.

t2(X) when (X#foo.baz =:= true) orelse (X#bar.baz =:= true) ->
  ok.

t3(X) when (X =:= true) orelse (X =:= 1) ->
  ok.

t4(X) when X orelse (X =:= 1) ->
  ok.
