%% -*- erlang-indent-level: 2 -*-
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ====================================================================
%%  Filename : 	external_pids.erl
%%  Module   :	external_pids
%%  Purpose  :  To test native code compilation of external pids.
%%  History  :	* 2002-09-04 Erik Stenman (happi@csd.uu.se):
%%		  Created.
%%		* 2003-03-12 Kostis Sagonas (kostis@csd.uu.se): 
%%		  Modified to be run without a shell script.
%%  CVS      :
%%              $Author: kostis $
%%              $Date: 2009/06/09 13:27:05 $
%%              $Revision: 1.6 $
%% ====================================================================
%%  Exports  :
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-module(external_pids).
-export([test/0,compile/1,a/0,b/1]).

test() ->
  OTP_DIR = os:getenv("OTP_DIR"),
  USER = os:getenv("USER"),
  MODULE = atom_to_list(?MODULE),
  R = os:cmd(OTP_DIR ++ "/bin/erl -sname " ++ USER ++ "_foo@localhost -noshell -s " ++ MODULE ++ " a"),
  list_to_atom(R).

compile(Opts) ->
  hipe:c(?MODULE,Opts).

%% -------------------------------------------------------------------

a() ->
  S = spawn(fun () -> server([]) end),
  global:register_name(t_serv, S),
  OTP_DIR = os:getenv("OTP_DIR"),
  USER = os:getenv("USER"),
  MODULE = atom_to_list(?MODULE),
  os:cmd(OTP_DIR ++ "/bin/erl -sname " ++ USER ++ "_bar@localhost -noshell -s " ++ MODULE ++ " b " ++ USER ++ "_foo@localhost").

b([Node]) ->
  spawn(fun() -> client(Node) end).

server(Msgs) ->
  receive
    {P, quit} ->
      P ! ack,
      io:format("~w~n",[Msgs]),
      halt();
    P when is_pid(P) ->
      server([pid|Msgs]);
    P ->
      server([P|Msgs])
  end.

client(Node) ->
  connect(Node),
  wait_server(),
  global:send(t_serv, self()),
  global:send(t_serv, {self(), quit}),
  receive
    ack -> halt()
  end.

connect(Node) ->
  case net_adm:ping(Node) of
    pong -> ok;
    _ -> connect(Node)
  end.

wait_server() ->
  case global:whereis_name(t_serv) of
    undefined -> wait_server();
    _ -> ok
  end.

