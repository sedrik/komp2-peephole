%%%-------------------------------------------------------------------
%%% File    : load_bug1.erl
%%% Author  : Per Gustafsson <pergu@it.uu.se>
%%% Description : This test case uncovers a bug which makes native 
%%%               compiled code call a generation too old beam code 
%%% Created : 15 Jun 2004 by Per Gustafsson <pergu@it.uu.se>
%%%-------------------------------------------------------------------
-module(load_bug1).

-export([test/0, compile/1]).

-define(ModName, load_bug1_mod).

compile(Flags) ->
  code:purge(?ModName),
  code:delete(?ModName),
  hipe:c(?MODULE,Flags).

test() ->
  %% io:format("here 1\n"),
  ModNameString = atom_to_list(?ModName),
  FN = write_file(ModNameString, <<"old">>),
  old = compile_and_run(FN),
  %% io:format("here ~s\n", [FN]),
  FN = write_file(ModNameString, <<"new">>),
  new = compile_and_run(FN),
  ok = file:delete(list_to_atom(FN)),
  %% io:format("here 3\n"),
  ok.

compile_and_run(FN) ->
  c:c(FN, []),
  ?ModName:tmp(). %% NOTE: name is statically known -- this is a remote call

write_file(ModNameString, Ret) ->
  ModBin = list_to_binary(ModNameString),
  Prog = construct_prog(ModBin, Ret),
  %% io:format("here 1.1\n"),
  FN = ModNameString ++ ".erl",
  file:write_file(FN, Prog),
  %% io:format("here 1.2\n"),
  FN.

construct_prog(ModBin, Ret) ->
  <<"-module(", ModBin/binary, ").\n",
    "-export([tmp/0]).\n",
    "tmp() ->\n", Ret/binary,".\n">>.
