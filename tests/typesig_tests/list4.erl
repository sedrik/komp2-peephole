%%%-------------------------------------------------------------------
%%% File    : list4.erl
%%% Author  : Tobias Lindahl <tobiasl@it.uu.se>
%%% Description : A bug in locally defined funs with unknown return
%%%
%%% Created : 16 Mar 2005 by Tobias Lindahl <tobiasl@it.uu.se>
%%%-------------------------------------------------------------------
-module(list4).

-export([t/1]).

t([Node|Left]) ->  
  NewLeft = lists:filter(fun(X) -> 
			     foo:bar(X)
			 end, Left),
  t(NewLeft);
t([]) ->
  ok.
