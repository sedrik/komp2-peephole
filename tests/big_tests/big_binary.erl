-module(big_binary).
-export([test/0,compile/1]).

compile(O) ->
  hipe:c(?MODULE,O).

test() ->
  case erlang:system_info(hipe_architecture) of
    amd64 ->
      Bin = <<0:80000000>>,
      Bin0 = list_to_binary([Bin,Bin,Bin,Bin,Bin]),
      Bin1 = list_to_binary([Bin0,Bin0,Bin0,Bin0,Bin0,Bin0]),
      {<<0,0,0,0,0,0,0,0,0,0,0,0,0,0,0>>,300000000,299999985} = start(Bin1),
      Bin2 = list_to_binary([Bin1,Bin1]),
      {<<0,0,0,0,0,0,0,0,0,0,0,0,0,0,0>>,600000000,599999985} = start(Bin2),
      ok;
    _ ->
      ok
  end.

start(Bin) ->
  <<Start:15/binary,Rem/binary>> = Bin,
  {Start,size(Bin),size(Rem)}.
