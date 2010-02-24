%%% Test that erl_printf_format.c:fmt_double() doesn't
%%% leak pending FP exceptions to subsequent code.
%%% This used to break x87 FP code on 32-bit x86.
%%%
%%% Based on a problem report from Richard Carlsson.

-module(fmt_double_fpe_leak).
-export([test/0, test/2, compile/1]).

test() ->
  test(a(), b()),
  ok.

%% We need the specific sequence of display/1 on a float that triggers
%% faulting ops in fmt_double() followed by a simple FP BIF.
%% We also need to repeat this at least 3 times.

test(X, Y) ->
  erlang:display(X), _ = math:log10(Y),
  erlang:display(X), _ = math:log10(Y),
  erlang:display(X), _ = math:log10(Y),
  erlang:display(X), _ = math:log10(Y),
  erlang:display(X),
  math:log10(Y).

a() ->
  0.0.

b() ->
  2.

compile(O) ->
  hipe:c(?MODULE, O).
