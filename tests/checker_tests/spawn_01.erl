%% -*- erlang-indent-level: 2 -*-

%% @author Daniel Luna <luna@update.uu.se>
%% @copyright 2008 Daniel Luna
%% 
%% @doc 
%% 

-module(spawn_01).
-export([test/0]).

test() ->
  spawn(fun() -> ok(not_ok) end),
  proc_lib:spawn(fun() -> ok(not_ok) end),
  spawn(fail_01, test, []),
  spawn_link(fun() -> fail_02:test() end),
  ok.

-spec(ok/1 :: (ok) -> ok).
ok(ok) -> ok.
