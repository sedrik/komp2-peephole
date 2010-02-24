%%%-------------------------------------------------------------------
%%% File    : bs_catch_bug.erl
%%% Author  : Per Gustafsson <pergu@it.uu.se>
%%% Description : Tests a catch-related bug which might destroy
%%%               properties of ICode CFGs which are assumed by
%%%               the subsequent ICode binary pass.
%%% Created : 22 Jan 2004 by Per Gustafsson <pergu@it.uu.se>
%%%-------------------------------------------------------------------

-module(bs_catch_bug).
-export([test/0, compile/1]).

compile(O) ->
  hipe:c(?MODULE,O).

test() ->
  test(foo,<<>>).

%% Introduced auxiliary test/2 function so that constant propagation
%% does not destroy the properties of the test. - Kostis 26/1/2004
test(X,Bin) ->
  catch (<<_/binary>> = X),
  X = case Bin of
        <<42,_/binary>> -> weird_bs_match;
	_ -> X
      end,
  ok.
