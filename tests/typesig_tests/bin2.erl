%%-------------------------------------------------------------------
%% File    : bin2.erl
%% Author  : Kostis Sagonas <kostis@it.uu.se>
%% Purpose : Test that we get precise information from binary
%%	     construction and that this information is propagated
%%	     forwards when refining the success typings.
%%
%% Created : 16 Sept 2006 by Kostis Sagonas <kostis@it.uu.se>
%%-------------------------------------------------------------------
-module(bin2).
-export([t/3]).

t(S,X,Y) ->
  I = i(X),
  F = f(Y),
  <<42:S, I:32, F:64/float>>.

i(X) -> 
  X + 1.

f(X) -> 
  X + 1.
