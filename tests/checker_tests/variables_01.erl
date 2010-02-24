%% -*- erlang-indent-level: 2 -*-

%% @author Daniel Luna <luna@update.uu.se>
%% @copyright 2008 Daniel Luna
%% 
%% @doc 
%% 

-module(variables_01).
-export([test/0]).

-spec(test/0 :: () -> ok).
test() ->
  test (a, a),
  test1(a, a),
  test2(a, a),
  test3(a, a),
  test4(a, a),
  test5(a, a),
  test6(a, a),
  ok.

-spec(test/2 :: (X, X) -> ok).
test(X, X) -> ok.

-spec(test1/2 :: (X, Y) -> ok when is_subtype(X, X), is_subtype(Y, Y)).
test1(X, X) -> ok.

-spec(test2/2 :: (X, X) -> ok when is_subtype(X, atom())).
test2(X, X) -> ok.

-spec(test3/2 :: (X, Y) -> ok when is_subtype(X, Y), is_subtype(Y, X)).
test3(X, X) -> ok.

-spec(test4/2 :: (X, Y) -> ok when is_subtype(X, Y), is_subtype(Y, X),
			   is_subtype(X, atom())).
test4(X, X) -> ok.

-spec(test5/2 :: (X, Y) -> ok when is_subtype(X, atom()),
			   is_subtype(X, Y), is_subtype(Y, X)).
test5(X, X) -> ok.

-spec(test6/2 :: (X, _Y) -> ok when is_subtype(X, atom())).
test6(X, X) -> ok.
