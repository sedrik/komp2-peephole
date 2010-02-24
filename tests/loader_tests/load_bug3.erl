%%% -*- erlang-indent-level: 2 -*-
%%%-------------------------------------------------------------------
%%% File    : load_bug3.erl
%%% Author  : Kostis Sagonas <kostis@it.uu.se>
%%% Description : This test case uncovers a bug which makes native 
%%%               compiled apply calls call BEAM code which is a
%%%               generation too old.
%%% Created : 18 Jun 2004 by Kostis Sagonas <kostis@it.uu.se>
%%%-------------------------------------------------------------------
-module(load_bug3).

-export([test/0, compile/1]).

compile(Flags) ->
  hipe:c(?MODULE,Flags).

test() ->
  ModNameString = form_unique_modname(),
  ModName = list_to_atom(ModNameString),
  {FN_erl,FN_beam} = write_file(ModNameString, <<"old">>),
  old = compile_and_run(FN_erl, ModName),
  {FN_erl,FN_beam} = write_file(ModNameString, <<"new">>),
  new = compile_and_run(FN_erl, ModName),
  ok = file:delete(list_to_atom(FN_erl)),
  ok = file:delete(list_to_atom(FN_beam)),
  ok.

form_unique_modname() ->
  {N1,N2,N3} = erlang:now(),
  USER = os:getenv("USER"),
  "lb3mod_" ++ USER ++ integer_to_list(N1) ++ integer_to_list(N2) ++ integer_to_list(N3).

compile_and_run(FN, ModName) ->
  c:c(FN, [{outdir, "/tmp/"}]),
  ModName:tmp(). % NOTE: Modname is statically unknown: this is an apply call

write_file(ModNameString, Ret) ->
  ModBin = list_to_binary(ModNameString),
  Prog = <<"-module(", ModBin/binary, ").\n",
	   "-export([tmp/0]).\n",
	   "tmp() ->\n", Ret/binary,".\n">>,
  Prefix = "/tmp/" ++ ModNameString,
  FN_erl = Prefix ++ ".erl",
  FN_beam = Prefix ++ ".beam",
  file:write_file(FN_erl, Prog),
  {FN_erl, FN_beam}.
