%%----------------------------------------------------------------------
%% From: Hunter Morris
%% Date: Nov 20, 2008; 08:26pm
%%
%% The following code (tested with R12B-4 or R12B-5, vanilla compiler
%% options) produces a compiler crash.  It's nonsensical, and I realise 
%% that andalso can be quite evil, but it's a crash nonetheless. 
%%----------------------------------------------------------------------

-module(morris_R12compiler_bug). 
-export([test/0, compile/1]). 

test() ->
  foo(42).

foo(Bar) when (is_integer(Bar) andalso Bar =:= 0) ; Bar =:= 42 -> 
  ok.

compile(Opts) ->
  hipe:c(?MODULE, Opts).

