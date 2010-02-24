%% ====================================================================
%% Test module for the HiPE test suite.
%%
%%  Filename : 	simpl_ne.erl
%%  Module   :	simpl_ne
%%  Purpose  :  Tests whether the translation of some guards works.
%%  History  :	* 2000-10-29 Kostis Sagonas (kostis@csd.uu.se): Created.
%% CVS:
%%    $Author: kostis $
%%    $Date: 2007/06/13 14:45:46 $
%%    $Revision: 1.4 $
%% ====================================================================
%% Exported functions (short description):
%%  test()         - execute the test.
%%  compile(Flags) - Compile to native code with compiler flags Flags.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-module(simpl_ne).
-export([test/0,compile/1]).

guard1(X) when X /= 0, is_float(X) ->
  ok.

guard2(X) when is_atom(X) orelse is_float(X) ->
  error1;
guard2(X) when is_reference(hd(X)) ->
  error2;
guard2(X) when is_integer(hd(X)) ->
  error3;
guard2(X) when hd(X) == foo ->
  ok.

test() ->
  ok = guard1(4.2),
  ok = guard2([foo]),
  ok.

compile(Flags) ->
  hipe:c(?MODULE, Flags).
