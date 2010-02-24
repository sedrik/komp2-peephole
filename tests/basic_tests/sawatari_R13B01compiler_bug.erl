%% From: Mikage Sawatari
%% Date: Jun 12, 2009; 07:28am
%% I have the following compilation problem on Erlang R13B01. 
%% Compiler reports "Internal consistency check failed". 

-module(sawatari_R13B01compiler_bug). 

-export([test/0, compile/1]). 

test() ->
  test([1,null,3], <<1,2,3>>).

test([], _Bin) -> ok;
test([H|T], Bin) -> 
  _ = case H of 
        null -> <<Bin/binary>>; 
        _ -> ok 
      end, 
  test(T, Bin). 

compile(Opts) ->
  hipe:c(?MODULE, Opts).
