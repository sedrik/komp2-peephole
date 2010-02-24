%%%-------------------------------------------------------------------
%%% File    : hybrid_binary.erl
%%% Author  : Per Gustafsson <pergu@it.uu.se>
%%% Description : 
%%%
%%% Created : 24 Oct 2006 by Per Gustafsson <pergu@it.uu.se>
%%%-------------------------------------------------------------------
-module(hybrid_binary).

-export([test/0,compile/1]).

compile(O) ->
  hipe:c(?MODULE,O).

test() ->
  Bin = <<1:8000000>>,
  Pid = spawn(fun counter/0),
  Pid ! {Bin,self()},
  loop().

loop() ->
  receive
    1 -> ok;
    _Other -> loop()
  end.

counter() ->
  receive
    {Bin,Pid} ->
      Pid ! count(Bin,Pid,0)
  end.

count(<<X,Rest/binary>>,Pid,N) ->
  Pid ! "I have performed " ++ integer_to_list(N) ++ "additions",
  X + count(Rest,Pid,N+1);
count(<<>>,_,_) -> 0.
