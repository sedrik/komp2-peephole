%%%-------------------------------------------------------------------
%% File: catch_merge.erl
%%
%% $Id: catch_merge.erl,v 1.2 2007/12/20 10:06:51 dalu7049 Exp $ 
%%
%% @author Richard Carlsson <richardc@it.uu.se>
%% @doc Test case that shows how Beam can merge catch-end blocks that
%% belong to different catch-start instructions.

-module(catch_merge).

-export([test/0,compile/1]).

test() ->
    m(get(whatever)).

m(foo=X) ->
    catch f(X),
    catch g(X);
m(X) ->
    catch f(X),
    catch g(X).

f(_) -> ok.

g(_) -> ok.

compile(Flags) ->
    hipe:c(?MODULE,Flags).
