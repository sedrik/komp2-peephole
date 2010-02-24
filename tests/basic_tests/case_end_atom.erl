-module(case_end_atom).
-export([test/0,compile/1]).
-compile([inline]).	%% necessary for this test

%%
%% Tests whether the translation of a case_end instruction works
%% when an exception (no matching case pattern) is to be raised.
%%

test() ->
%%   {'EXIT',{{case_clause,some_atom},[_|_]}} = (catch test_case_stm_inlining()),
  {'EXIT',{{case_clause,some_atom},_Trace}} = (catch test_case_stm_inlining()),
  ok.

test_case_stm_inlining() ->
  case some_atom() of
    another_atom -> strange_result
  end.

some_atom() ->
  some_atom.

compile(O) ->
  hipe:c(?MODULE,O).

