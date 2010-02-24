%% Time-stamp: <99/12/03 13:15:00 happi>
%% ====================================================================
%%  Filename : 	length.erl
%%  Module   :	length
%%  History  :	1996-06-17 Christer Jonsson (d92cjo@csd.uu.se): Created.
%%              1999-12-03 Erik Johansson (happi@csd.uu.se): 
%%                         Rewritten for testing.
%% CVS:
%%    $Author: kostis $
%%    $Date: 2001/02/13 16:49:25 $
%%    $ $
%% ====================================================================
%% Exported functions (short description):
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-module(length).
-export([test/0,compile/1]).


test() ->
   L = mklist(20, []),
   R = iterate(10, L),
   {length, R}.

compile(Flags) ->
    hipe:c(?MODULE,Flags).
  
  
iterate(0, L) ->    len(L, 0);
iterate(X, L) ->
   len(L, 0),
   iterate(X-1, L).


len([_|X], L) ->
   len(X, L+1);
len([], L) ->
   L.


mklist(0, L) ->
   L;
mklist(X, L) ->
   mklist(X-1, [X|L]).
