%%%-------------------------------------------------------------------
%%% File    : merged_catches.erl
%%% Author  : Tobias Lindahl <tobiasl@csd.uu.se>
%%% Description : 
%%%
%%% Created : 22 Mar 2004 by Tobias Lindahl <tobiasl@csd.uu.se>
%%%-------------------------------------------------------------------
-module(merged_catches).

-export([test/0, compile/1]).

test() ->
  {'EXIT', _} = merged_catches(foo),
  {'EXIT', {badarith, _}} = merged_catches(bar),
  {'EXIT', _} = merged_catches(baz),
  ok.

merged_catches(X) ->
  case X of
    foo -> catch fail1(0);
    bar -> catch {catch(1 = X), fail2(0)};
    baz -> catch fail3(0)
  end.

fail1(X)->
  1/X.

fail2(X)->
  1/X.

fail3(X)->
  1/X.

compile(Opts) ->
  hipe:c(?MODULE, Opts).
