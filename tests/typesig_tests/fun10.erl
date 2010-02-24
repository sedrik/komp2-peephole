%%%-------------------------------------------------------------------
%%% File    : fun10.erl
%%% Author  : Tobias Lindahl <tobiasl@csd.uu.se>
%%% Description : Defining a fun and applying it without assigning 
%%                it to a variable in a list comprehension triggered a 
%%                dependency bug in the analysis.
%%%
%%% Created : 24 Oct 2006 by Tobias Lindahl <tobiasl@csd.uu.se>
%%%-------------------------------------------------------------------
-module(fun10).

-export([t/1]).

t(List) -> 
  [fun() -> 1 end() || _ <- List].
