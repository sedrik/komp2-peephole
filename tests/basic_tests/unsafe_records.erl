%%%-------------------------------------------------------------------
%%% File    : unsafe_records.erl
%%% Author  : Tobias Lindahl <tobiasl@csd.uu.se>
%%% Description : BEAM can construct unguarded unsafe_element operations 
%%%               on records.
%%%
%%% Created :  1 Jun 2004 by Tobias Lindahl <tobiasl@csd.uu.se>
%%%-------------------------------------------------------------------
-module(unsafe_records).
-export([test/0, compile/1]).

-record(foo, {bar, baz}).

test() ->
  catch doit(1),
  ok.

doit(X)->
  X#foo{bar=X#foo.baz}.

compile(Opts) ->
  hipe:c(?MODULE, Opts).
  
