%% ====================================================================
%% Test module for the HiPE test suite.
%%
%%  Filename :  no_inline_fp.erl
%%  Purpose  :  A trivial test to make sure that compilation with the
%%		`no_inlune_fp' HiPE compiler option on is possible.
%%  History  :  * 2004-4-21 Kostis Sagonas (kostis@it.uu.se): Created.
%% CVS:
%%    $Author: kostis $
%%    $Date: 2004/04/21 12:34:37 $
%%    $Revision: 1.1 $
%% ====================================================================

-module(no_inline_fp).
-export([test/0, compile/1]).
%%-compile({hipe,[no_inline_fp]}).

test() ->
  compile([o2]),
  round(fl(84.0)).

fl(X) when is_float(X) -> X / 2.

compile(Opts) ->
  hipe:c(?MODULE, [no_inline_fp|Opts]).
