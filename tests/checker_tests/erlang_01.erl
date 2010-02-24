%% -*- erlang-indent-level: 2 -*-

%% @author Daniel Luna <luna@update.uu.se>
%% @copyright 2008 Daniel Luna
%% 
%% @doc 
%% 

-module(erlang_01).
-export([test/0]).

test() ->
  [_|_] = erlang:fun_info(fun test/0),
  ok.
