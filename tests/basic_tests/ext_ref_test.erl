-module(ext_ref_test).
-export([test/0,compile/1]).

test() ->
  test(an_external_ref()).

test(Ref) when is_reference(Ref) ->
  ok;
test(_Ref) ->
  buggy_ext_ref_test.

an_external_ref() ->
  binary_to_term(<<131,114,0,3,100,0,19,114,101,102,95,116,101,115,116,95,98,117,103,64,103,111,114,98,97,103,2,0,0,0,125,0,0,0,0,0,0,0,0>>).

compile(O) ->
  hipe:c(?MODULE,O).
