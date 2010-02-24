%%-------------------------------------------------------------------
%% File    : higher_order1.erl
%% Author  : Kostis Sagonas <kostis@it.uu.se>
%% Description : Tests calls to higher-order functions.
%%
%% Created : 7 Jul 2005 by Kostis Sagonas <kostis@it.uu.se>
%%-------------------------------------------------------------------

-module(higher_order1).
-export([test/1, bar/1, foo/2]).

% spec test(1 | 2) -> ((1 | 2 | 3) -> ok)
test(X) ->
  foo(R = fun bar/1, X),
  R.

% spec bar(1 | 2 | 3) -> ok
bar(X) ->
  case X of
    1 -> ok;
    2 -> ok;
    3 -> ok
  end.

% spec foo(((1|2) -> (ok | not_ok)), 1 | 2) -> ok | not_ok
foo(F, X) ->
  case X of
    1 -> ok = F(X);
    2 -> not_ok = F(X)
  end.
	
