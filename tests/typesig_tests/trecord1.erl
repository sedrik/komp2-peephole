%%%-------------------------------------------------------------------
%%% File    : trecord1.erl
%%% Author  : Tobias Lindahl <tobiasl@csd.uu.se>
%%% Description : 
%%%
%%% Created : 27 Nov 2006 by Tobias Lindahl <tobiasl@csd.uu.se>
%%%-------------------------------------------------------------------
-module(trecord1).

-record(rec0, {a}).
-record(rec1, {a :: float()}).
-record(rec2, {bar=1 :: integer(),
	       baz::#rec1{}}).

-export([t1/1, t2/1, t3/1, t4/1, t5/1]).

t1(X) when is_record(X, rec2) ->
  X.

t2(#rec2{bar=X}) ->
  X.

t3(#rec2{bar=1.0}) ->
  error;
t3(#rec2{bar=1}) ->
  ok.

t4(#rec2{baz=#rec1{a=X}}) ->
  X.

t5(#rec2{baz=X}) ->
  X.
