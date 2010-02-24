%%%-------------------------------------------------------------------
%%% File    : bs20.erl
%%% Author  : Per Gustafsson <pergu@jobberl>
%%% Description : Resizes matchstates
%%%
%%% Created : 12 Nov 2007 by Per Gustafsson <pergu@jobberl>
%%%-------------------------------------------------------------------
-module(bs20).

-export([test/0,compile/1]).

compile(O) ->
  hipe:c(?MODULE, O).

test() ->
  30 = match(<<1,2,3,4,5,6,7,8,9,10>>,0),
  ok.

match(<<_:4,A:4,Rest/binary>>,Acc) ->
 case Rest of
   <<X,Y,9,NewRest/binary>> ->
     match(NewRest,X+Y+Acc);
   <<X,5,NewRest/binary>> ->
     match(NewRest,X+Acc);
   <<2,NewRest/binary>> ->
     match(NewRest,1+Acc);
   <<NewRest/binary>> ->
     match(NewRest,A+Acc)
  end;
match(<<>>, Acc) -> Acc.
