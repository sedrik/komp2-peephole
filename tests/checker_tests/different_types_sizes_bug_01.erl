%% -*- erlang-indent-level: 2 -*-

%% @author Daniel Luna <luna@update.uu.se>
%% @copyright 2008 Daniel Luna
%% 
%% @doc 
%% 

-module(different_types_sizes_bug_01).
-export([test/0]).

%% Code minimized from code_server:do_load_binary/4
test() ->
  case {true()} of
    {true} -> ok
  end.

true() -> true.
