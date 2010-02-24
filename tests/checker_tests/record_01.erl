%% -*- erlang-indent-level: 2 -*-

%% @author Daniel Luna <luna@update.uu.se>
%% @copyright 2008 Daniel Luna
%% 
%% @doc 
%% 

-module(record_01).
-export([test/0]).

-record(rec, {bla :: []}).

-type(rec() :: #rec{}).

-spec(test/0 :: () -> rec()).
test() ->
  #rec{}.

