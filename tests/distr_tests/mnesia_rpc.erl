%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% -*- erlang-indent-level: 2 -*-
%% ====================================================================
%%  Filename : 	mnesia_rpc.erl
%%  Module   :	mnesia_rpc
%%  Purpose  :  To test native code compilation and shared heap
%%              behaviour of rpc and external pids.
%%  History  :	* 2003-03-24 Jesper Wilhelmsson (jesperw@csd.uu.se):
%%		  Created.
%%  CVS      :
%%              $Author: kostis $
%%              $Date: 2009/03/17 08:54:48 $
%%              $Revision: 1.11 $
%% ====================================================================
%%  Exports  :
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-module(mnesia_rpc).
-export([test/0,compile/1]).
-export([start/1,normal_normal/1,normal_sticky/1,sync_normal/1,sync_sticky/1]).

-define(TABLE, replicated_table).
-define(RECORD, {?TABLE, key, value}).

test() ->
  OTP_DIR = os:getenv("OTP_DIR"),
  ERL_FLAGS = os:getenv("ERL_FLAGS"),
  USER = os:getenv("USER"),
  MODULE = atom_to_list(?MODULE),
  ERL = OTP_DIR ++ "/bin/erl " ++ ERL_FLAGS,
  NODE_A = USER ++ "_a@localhost",
  NODE_B = USER ++ "_b@localhost",
  os:cmd(ERL ++ " -sname " ++ NODE_A ++ " -noshell &"),
  receive after 1000 -> ok end,		% prevent race condition
  S = os:cmd(ERL ++ " -sname " ++ NODE_B ++ " -noshell -noinput -s "
	     ++ MODULE ++ " start " ++ NODE_A),
  %% io:format("Output from node B: ~s\n",[S]),
  {match,[{Pos,Len}]} = re:run(S, "TestResult:"),
  R = string:sub_string(S, Pos+1+Len+1),
  list_to_atom(R).

compile(Opts) ->
  hipe:c(?MODULE,Opts).

%% -------------------------------------------------------------------

start([TheOtherNode]) ->
    init_node_and_table(TheOtherNode),
    run_tests(2000),
    shutdown(TheOtherNode),
    io:format("TestResult: ~w",[net_adm:ping(TheOtherNode)]),
    rpc:call(TheOtherNode,erlang,halt,[]),
    halt().

init_node_and_table(TheOtherNode) ->
    pong = net_adm:ping(TheOtherNode),
    mnesia:start(),
    ok = rpc:call(TheOtherNode, mnesia, start, []),
    
    {ok,[TheOtherNode]} = mnesia:change_config(extra_db_nodes, [TheOtherNode]),
    
    {atomic, ok} = mnesia:create_table(?TABLE, []),
    {atomic, ok} = mnesia:add_table_copy(?TABLE, TheOtherNode, ram_copies).

shutdown(TheOtherNode) ->
    mnesia:delete_table(?TABLE),
    mnesia:stop(),
    rpc:call(TheOtherNode, mnesia, stop, []).

run_tests(Times) ->
    _Seq = lists:seq(1, Times),
    
%%    io:fwrite("~nNormal write-lock in normal transaction"),
    {_Time1, ok} = timer:tc(?MODULE, normal_normal, [Times]),
%%    report(Time1, Times),
    
%%    io:fwrite("~nSticky write-lock in normal transaction"),
    {_Time2, ok} = timer:tc(?MODULE, normal_sticky, [Times]),
%%    report(Time2, Times),
    
%%    io:fwrite("~nNormal write-lock in sync_transaction"),
    {_Time3, ok} = timer:tc(?MODULE, sync_normal, [Times]),
%%    report(Time3, Times),
    
%%    io:fwrite("~nSticky write-lock in sync_transaction"),
    {_Time4, ok} = timer:tc(?MODULE, sync_sticky, [Times]).
%%    report(Time4, Times).

%%report(Time, Times) ->
%%    io:fwrite("~n~p transactions in ~p seconds or " ++
%%	      "~p microseconds / transaction.", 
%%	      [Times, Time / 1000000.0, Time / Times]).

normal_normal(0) -> ok;
normal_normal(Times) ->
    mnesia:transaction(fun normal_write/0),
    normal_normal(Times - 1).

normal_sticky(0) -> ok;
normal_sticky(Times) ->
    mnesia:transaction(fun sticky_write/0),
    normal_sticky(Times - 1).

sync_normal(0) -> ok;
sync_normal(Times) ->
    mnesia:sync_transaction(fun normal_write/0),
    sync_normal(Times - 1).

sync_sticky(0) -> ok;
sync_sticky(Times) ->
    mnesia:sync_transaction(fun sticky_write/0),
    sync_sticky(Times - 1).

normal_write() ->
    mnesia:write(?TABLE, ?RECORD, write).

sticky_write() ->
    mnesia:write(?TABLE, ?RECORD, sticky_write).
