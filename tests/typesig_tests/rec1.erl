%%%-------------------------------------------------------------------
%%% File    : rec1.erl
%%% Author  : Tobias Lindahl <tobiasl@it.uu.se>
%%% Description : 
%%%
%%% Created : 21 Dec 2004 by Tobias Lindahl <tobiasl@it.uu.se>
%%%-------------------------------------------------------------------
-module(rec1).
-export([traverse_linked_list/1]).

traverse_linked_list({Content, nil}) ->
  [Content];
traverse_linked_list({Content, Next}) ->
  [Content] ++ traverse_linked_list(Next).
