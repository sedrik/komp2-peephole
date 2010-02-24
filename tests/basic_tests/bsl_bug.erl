%%%-------------------------------------------------------------------
%%% File    : bsl_bug.erl
%%% Author  : Per Gustafsson <pergu@it.uu.se>
%%% Description :
%%%	The first part of this test triggers a bug in the emulator
%%%     as one of the arguments to bsl is not an integer.
%%%	The second part of this test triggered a compilation crash
%%%	since an arithmetic expression resulting in a 'system_limit'
%%%	exception was statically evaluated and an arithmetic result
%%%	was expected.
%%%
%%% Created : 28 Sep 2006 by Per Gustafsson <pergu@it.uu.se>
%%%-------------------------------------------------------------------
-module(bsl_bug).
-export([test/0, compile/1]).

test() ->
  {'EXIT', {'badarith', _}} = (catch (t1(0, pad, 0))),
  {'EXIT', {'badarith', _}} = (catch (t2(0, pad, 0))),
  {'EXIT', {'system_limit', _}} = (catch (id(1) bsl 100000000)),
  ok.

t1(_, X, _) ->
  (1 bsl X) + 1.

t2(_, X, _) ->
  (X bsl 1) + 1.

id(I) -> I.

compile(O) -> 
  hipe:c(?MODULE, O).
