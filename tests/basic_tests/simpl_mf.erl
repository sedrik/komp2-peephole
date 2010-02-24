%% ====================================================================
%% Test module for the HiPE test suite.
%%
%%  Filename :  simpl_mf.erl
%%  Module   :  simpl_mf
%%  Purpose  :  Tests whether the translation of make_fun works.
%%  History  :  * 2000-10-28 Kostis Sagonas (kostis@csd.uu.se): Created.
%% CVS:
%%    $Author: richardc $
%%    $Date: 2004/08/20 14:59:04 $
%%    $Revision: 1.8 $
%% ====================================================================
%% Exported functions (short description):
%%  test()         - execute the test.
%%  compile(Flags) - Compile to native code with compiler flags Flags.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-module(simpl_mf).
-export([test/0,compile/1]).

contains_fun(X,_IGNORED_ARG,Y) ->
  calls_fun(fun(Term) -> {X,Term,Y} end).

calls_fun(F) ->
  F({bound_var,[seems,ok]}).

double_the_fun() ->
  {fun () -> ok end,
   fun (V) -> {double_the_fun,V} end}.

test() ->
  {F,G} = double_the_fun(),
  {contains_fun({free_var1,ok},ignored,{free_var2,{is,also,ok}}), [F(),G(ok)]}.

compile(Opts) ->
  case proplists:get_bool(core, Opts) of
    false ->
      hipe:c({?MODULE,contains_fun,3},Opts),
      hipe:c({?MODULE,calls_fun,1},Opts),
      hipe:c({?MODULE,double_the_fun,0},Opts),
      {ok,?MODULE};
    true ->
      test:note(?MODULE, "native-compiling whole module"),
      hipe:c(?MODULE,Opts)
  end.
